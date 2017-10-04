/**
 * This is a wrapper around the InkyJS story object. Provides various utility methods for querying
 * the story, as well as acting as a state container for asset loading.
 */

import Bluebird from 'bluebird';

const loadImageMemo = {};
let preloadDone = false;

// decide the maximum image width up front
// const maxImageWidth = (() => {
//   // This approach isn't completely optimised, and it doesn't cover the case where a user moves
//   // from one screen to another or changes their orientation. But it should give acceptable results,
//   // and prevent cases of silly bandwidth usage, like loading 2000px images on a small phone.
//
//   // define a limited set of possible widths so we don't hammer the image service with too many
//   // image variations
//   const acceptableWidths = [320, 480, 768, 1024, 1280, 1440, 1920];
//
//   // choose the closest acceptable width for the current viewport (rounding up)
//   const minWidth = acceptableWidths.shift();
//   const maxWidth = acceptableWidths.pop();
//
//   let idealWidth = minWidth;
//
//   acceptableWidths.forEach((width, i) => {
//     if (i === 0) return;
//     const current = acceptableWidths[i - 1];
//     const previous = acceptableWidths[i - 1];
//
//     if (innerWidth > previous && innerWidth <= current) {
//       idealWidth = current;
//     }
//   });
//
//   if (idealWidth > maxWidth) idealWidth = maxWidth;
//
//   invariant(idealWidth >= innerWidth, 'ideal width must be big enough for screen');
//   invariant(idealWidth >= 320, 'idealWidth cannot be less than 320');
//   invariant(idealWidth <= 1920, 'idealWidth cannot be greater than 1920');
//
//   return idealWidth * 2; // because ugh these images are cropped... might be best to crop via image service
// })();

const maxImageWidth = 1800; // TEMP
const dpr = devicePixelRatio || 1;

export default class StateUtils {
  constructor(story, config) {
    this.config = config;
    this.story = story;
  }

  /**
   * Gets the 'value' of a prefixed tag, e.g. getTagValue('bg') will return "foo" if the tag
   * "bg:foo" currently exists. Otherwise returns null.
   */
  getTagValue(prefix) {
    const tags = this.story.currentTags;

    for (let i = 0, l = tags.length; i < l; i += 1) {
      const tag = tags[i];
      if (tag.startsWith(`${prefix}:`)) return tag.replace(`${prefix}:`, '');
    }

    return null;
  }

  /**
   * Returns either 'Prius' or 'minivan'
   */
  getCarType() {
    const carType = this.story.variablesState.$('car');
    if (carType !== 'Prius' && carType !== 'minivan') {
      throw new Error(`Unexpected carType: ${carType}`);
    }
    return carType;
  }

  // eslint-disable-next-line class-methods-use-this
  getImageServiceURL(url, transparent = false) {
    return `https://www.ft.com/__origami/service/image/v2/images/raw/${encodeURIComponent(
      url,
    )}?source=ig&width=${maxImageWidth}&dpr=${dpr}&format=${transparent
      ? 'png'
      : 'jpg'}&quality=high`;
  }

  /**
   * Memoized image-loading function. If called multiple times with the same image, only loads once.
   *
   * This returns a blob, which can then be used as a background image via
   * `URL.createObjectURL(blob)`.
   */
  async loadImage(originalURL, transparent = false) {
    const token = `${transparent}_${originalURL}`;

    if (!loadImageMemo[token]) {
      loadImageMemo[token] = new Bluebird((resolve, reject) => {
        // convert URL to Image Service
        const url = this.getImageServiceURL(originalURL, transparent);
        // load the image (with three attempts)
        const retry = async () => {
          await Bluebird.delay(100);
          return fetch(url);
        };

        fetch(url)
          .catch(retry)
          .catch(retry)
          .then(res => res.blob())
          .then(resolve, (error) => {
            // delete from memo so it's still possible to load it later
            delete loadImageMemo[token];
            reject(error);
          });
      });
    }

    // preload remaining images if this is the first one
    if (!preloadDone) {
      // TODO only download images for the car type we actually need
      this.preloadAllImages('prius').then(() => {
        this.preloadAllImages('minivan');
      });

      preloadDone = true;
    }

    return loadImageMemo[token];
  }

  // eslint-disable-next-line class-methods-use-this
  isImageLoaded(url) {
    return loadImageMemo[url] && loadImageMemo[url].isFulfilled();
  }

  /**
   * Sets off a chain preloading the images. Failure to load is OK.
   */
  async preloadAllImages(carType) {
    await Bluebird.mapSeries(Object.keys(this.config.backgroundImages), (key) => {
      const url = this.config.backgroundImages[key][carType];
      if (url) return this.loadImage(url).catch(() => {});
      return null;
    });
  }

  /**
   * Returns the appropriate background image URL for the current scene.
   */
  getBackgroundImageURL() {
    const bgImages = this.config.backgroundImages;

    const bgName = this.getTagValue('bg');

    if (bgName && bgImages[bgName]) {
      return bgImages[bgName][this.getCarType().toLowerCase()] || null;
    }

    return null;
  }

  getInitialBackgroundImage() {
    return this.config.initialBackgroundImage;
  }
}

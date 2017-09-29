/**
 * This is a wrapper around the InkyJS story object. Provides various utility methods for querying
 * the story, as well as acting as a state container for asset loading.
 */

const loadImageMemo = {};

const delay = milliseconds =>
  new Promise((resolve) => {
    setTimeout(resolve, milliseconds);
  });

const loadImage = url =>
  new Promise((resolve, reject) => {
    const img = new Image();
    img.src = url;
    img.addEventListener('load', () => {
      resolve(img);
    });
    img.addEventListener('error', reject);
  });

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

  /**
   * Memoized image-loading function. If called multiple times with the same image, only loads once.
   */
  // eslint-disable-next-line class-methods-use-this
  async loadImage(url) {
    if (!loadImageMemo[url]) {
      loadImageMemo[url] = new Promise((resolve, reject) => {
        // load the image (three attempts)
        loadImage(url)
          .catch(async () => {
            await delay(200);
            return loadImage(url);
          })
          .catch(async () => {
            await delay(200);
            return loadImage(url);
          })
          .then(resolve, (error) => {
            // allow trying again later (e.g. when back online)
            delete loadImageMemo[url];
            reject(error);
          });
      });
    }

    return loadImageMemo[url];
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
}

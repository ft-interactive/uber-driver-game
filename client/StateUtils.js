/**
 * This is a wrapper around the InkyJS story object. Provides various utility methods for querying
 * the story, as well as acting as a state container for asset loading.
 */

import Bluebird from 'bluebird';

const loadImageMemo = {};

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
  getImageServiceURL(url) {
    return `https://www.ft.com/__origami/service/image/v2/images/raw/${encodeURIComponent(
      url,
    )}?source=ig&width=2000&format=jpg&quality=high`;
  }

  /**
   * Memoized image-loading function. If called multiple times with the same image, only loads once.
   *
   * This returns a blob, which can then be used as a background image via
   * `URL.createObjectURL(blob)`.
   */
  async loadImage(originalURL) {
    if (!loadImageMemo[originalURL]) {
      loadImageMemo[originalURL] = new Bluebird((resolve, reject) => {
        // convert URL to Image Service
        const url = this.getImageServiceURL(originalURL);

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
            delete loadImageMemo[originalURL];
            reject(error);
          });
      });
    }

    return loadImageMemo[originalURL];
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

import Bluebird from 'bluebird';

export default class GameContainer {
  constructor(element, stateUtils) {
    this.element = element;
    this.stateUtils = stateUtils;
  }

  async setBackgroundImage(url) {
    // TODO check stateUtils.isImageLoaded(url) first (use bluebird), in which case forget loading
    // indicator

    this.element.classList.add('game-container--loading');

    // TODO remove this fake delay
    await Bluebird.delay(1000);

    const img = await this.stateUtils.loadImage(url);

    console.log('SETTING BACKGROUND TO', url, img);

    this.element.style.backgroundImage = `url(${url})`; // TODO maybe transition?

    this.element.classList.remove('game-container--loading');
  }
}

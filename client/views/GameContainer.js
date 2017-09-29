import Bluebird from 'bluebird';

const getBackgroundDiv = (url) => {
  const div = document.createElement('div');
  div.classList.add('game-container__background-image');
  div.style.backgroundImage = `url(${url})`;
  return div;
};

export default class GameContainer {
  constructor(element, stateUtils) {
    this.element = element;
    this.stateUtils = stateUtils;
  }

  initialise() {
    this.currentBackgroundURL = null;

    this.backgroundContainer = this.element.querySelector('.game-container__background');

    // start with the specially defined 'initial image' from config
    this.currentBackgroundURL = this.stateUtils.getInitialBackgroundImage();
    const div = getBackgroundDiv(this.stateUtils.getImageServiceURL(this.currentBackgroundURL));
    this.backgroundContainer.appendChild(div);
    this.currentBackground = div;
  }

  async setBackgroundImage(url) {
    if (this.currentBackgroundURL === url) return;

    this.currentBackgroundURL = url;

    const alreadyLoaded = this.stateUtils.isImageLoaded(url);

    if (!alreadyLoaded) this.element.classList.add('game-container--loading');

    const [blob] = await Promise.all([this.stateUtils.loadImage(url), Bluebird.delay(500)]);

    const newBackground = getBackgroundDiv(URL.createObjectURL(blob));
    const oldBackground = this.currentBackground;

    this.currentBackground = newBackground;

    // swap them
    newBackground.style.opacity = '0';
    this.backgroundContainer.appendChild(newBackground);

    this.element.classList.remove('game-container--loading');

    newBackground.getBoundingClientRect(); // trigger paint
    newBackground.style.opacity = 1;

    await Bluebird.delay(2000);
    oldBackground.remove();
  }
}

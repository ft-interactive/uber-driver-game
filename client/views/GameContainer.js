import anime from 'animejs';

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

    // TODO check stateUtils.isImageLoaded(url) first (use bluebird), in which case forget loading
    // indicator

    this.element.classList.add('game-container--loading');

    const blob = await this.stateUtils.loadImage(url);

    const newBackground = getBackgroundDiv(URL.createObjectURL(blob));
    const oldBackground = this.currentBackground;

    this.currentBackground = newBackground;

    // swap them
    newBackground.style.opacity = '0';
    this.backgroundContainer.appendChild(newBackground);

    // await Bluebird.delay(100);

    anime({
      targets: newBackground,
      opacity: 1,
      duration: 2000,
      complete: () => {
        if (oldBackground) oldBackground.remove();
      },
    });

    setTimeout(() => {
      this.element.classList.remove('game-container--loading');
    }, 500);
  }
}

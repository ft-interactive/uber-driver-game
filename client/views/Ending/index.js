import anime from 'animejs';

const GREY_BG = '#333';

const elem = (tagName, attributes, _children) => {
  const el = document.createElement(tagName);

  if (attributes) {
    Object.keys(attributes).forEach((name) => {
      el.setAttribute(name, attributes[name]);
    });
  }

  if (!_children) return el;

  const children = Array.isArray(_children) ? _children : [_children];

  children.forEach((child) => {
    if (typeof child === 'string') {
      const textNode = document.createTextNode(child);
      el.appendChild(textNode);
    } else {
      el.appendChild(child);
    }
  });

  return el;
};

export default class Ending {
  constructor(element, stateUtils) {
    this.element = element;
    this.stateUtils = stateUtils;
  }

  async show() {
    // add class to reveal the element
    this.element.classList.add('ending--visible');

    const width = innerWidth;
    const height = innerHeight;

    // make a canvas for the splash animation
    const splash = elem('canvas', { class: 'ending__splash' });
    splash.width = width;
    splash.height = height;
    const context = splash.getContext('2d');
    this.element.appendChild(splash);

    const duration = 1000;

    // perform splash animation on canvas
    await new Promise((resolve) => {
      let startTime;
      const drawFrame = (ms) => {
        if (!startTime) startTime = ms;

        // const elapsedProportion = Math.min((ms - startTime) / duration, 1);
        const elapsedProportion = (ms - startTime) / duration;

        // clear the whole canvas
        context.clearRect(0, 0, width, height);

        // fill with grey - TODO use a path, fill the grey with an angled top, and fill the top line
        // with blue, and add confetti
        context.fillStyle = GREY_BG;
        context.fillRect(0, height * (1 - elapsedProportion), width, height);

        // draw next frame if appropriate
        if (elapsedProportion < 1) requestAnimationFrame(drawFrame);
        else resolve();
      };

      requestAnimationFrame(drawFrame);
    });

    // make background solid and remove canvas
    this.element.style.background = GREY_BG;
    splash.remove();

    // show the stats
    const stats = elem('div', { class: 'ending__stats' }, [
      elem('div', { class: 'ending__heading' }, [
        elem('div', { class: 'ending__heading-rule' }),
        'Your stats',
        elem('div', { class: 'ending__heading-rule' }),
      ]),

      elem('div', { class: 'ending__heading' }),
    ]);

    this.element.appendChild(stats);

    // const windowHeight = window.innerHeight;
    // anime.timeline().add({
    //   targets: splash,
    //   translateY: 0 - windowHeight,
    //   easing: 'easeInQuad',
    //   duration: 1500,
    // });
    // .add({
    //   targets: stripe,
    //   height: '300px',
    //   // transform: rotateZ(-20deg) translateX(-40%);
    //
    //   duration: 1500,
    //   offset: -1500,
    // });
    // .add({
    //   targets:
    // })
  }
}

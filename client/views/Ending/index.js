export default class Ending {
  constructor(element, stateUtils) {
    this.element = element;
    this.stateUtils = stateUtils;
  }

  initialise() {
    // do any startup stuff
  }

  show() {
    this.element.classList.add('ending--active');
  }
}

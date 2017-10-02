import React, { Component } from 'react';
import PropTypes from 'prop-types';

export default class Splash extends Component {
  // constructor() {
  //   super();
  // }

  componentDidMount() {
    this.animate();
  }

  animate() {
    const duration = 1000;

    const width = this.canvas.width;
    const height = this.canvas.height;

    const context = this.canvas.getContext('2d');

    let startTime;

    const drawFrame = (ms) => {
      if (!startTime) startTime = ms;

      // const elapsedProportion = Math.min((ms - startTime) / duration, 1);
      const elapsedProportion = (ms - startTime) / duration;

      // clear the whole canvas
      context.clearRect(0, 0, width, height);

      // fill with grey - TODO use a path, fill the grey with an angled top, and fill the top line
      // with blue, and add confetti
      context.fillStyle = '#333';
      context.fillRect(0, height * (1 - elapsedProportion), width, height);

      // draw next frame if appropriate
      if (elapsedProportion < 1) requestAnimationFrame(drawFrame);
      else this.props.onAnimationComplete();
    };

    requestAnimationFrame(drawFrame);
  }

  render() {
    let canvas;

    // create component and get a reference to the canvas element itself
    return <canvas ref={el => (this.canvas = el)} height={innerHeight} width={innerWidth} />;
  }
}

Splash.propTypes = {
  onAnimationComplete: PropTypes.func.isRequired,
};

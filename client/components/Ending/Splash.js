// @flow

import React, { Component } from 'react';
import * as colours from './colours';

// eslint-disable-next-line no-confusing-arrow
const ease = (t: number) =>
  // eslint-disable-next-line no-mixed-operators
  t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1;

type Props = {
  onAnimationComplete: () => void,
};

export default class Splash extends Component<Props> {
  componentDidMount() {
    const duration = 1300;

    const width = this.canvas.width;
    const height = this.canvas.height;

    const context = this.canvas.getContext('2d');

    let startTime;

    const drawFrame = (ms) => {
      if (!startTime) startTime = ms;

      const elapsedProportion = ease((ms - startTime) / duration);

      // clear the whole canvas
      context.clearRect(0, 0, width, height);

      // fill with grey - TODO use a path, fill the grey with an angled top, and fill the top line
      // with blue, and add confetti
      context.fillStyle = colours.darkGrey;
      context.fillRect(0, height * (1 - elapsedProportion), width, height);

      // draw next frame if appropriate
      if (elapsedProportion < 1) requestAnimationFrame(drawFrame);
      else this.props.onAnimationComplete();
    };

    requestAnimationFrame(drawFrame);
  }

  props: Props;
  canvas: HTMLCanvasElement;

  render() {
    let canvas;

    // create component and get a reference to the canvas element itself
    return (
      <canvas
        ref={(el) => {
          if (el) this.canvas = el;
        }}
        height={window.innerHeight}
        width={window.innerWidth}
      />
    );
  }
}

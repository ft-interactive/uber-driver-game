// @flow

import React, { Component } from 'react';
import easeQuintInOut from 'eases/quint-in-out';
import * as colours from './colours';
import animate from '../../lib/animate';

type Props = {
  onAnimationComplete: () => void,
};

export default class Splash extends Component<Props> {
  componentDidMount() {
    const width = this.canvas.width;
    const height = this.canvas.height;
    const context = this.canvas.getContext('2d');

    animate(
      (elapsedProportion) => {
        // clear the whole canvas
        context.clearRect(0, 0, width, height);

        // fill with grey - TODO use a path, fill the grey with an angled top, and fill the top line
        // with blue, and add confetti
        context.fillStyle = colours.darkGrey;
        context.fillRect(0, height * (1 - elapsedProportion), width, height);
      },
      {
        duration: 1300,
        ease: easeQuintInOut,
      },
    ).then(() => {
      this.props.onAnimationComplete();
    });
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

/**
 * This is used for both the 'income' and 'costs' panels, which both add/subtract several values one
 * by one to modify the player's net total, which is displayed in big text at the top.
 */

// @flow

import React, { Component } from 'react';
import Bluebird from 'bluebird';
import Panel from './Panel';
import formatDollars from '../../../lib/formatDollars';
import animate from '../../../lib/animate';
import * as colours from '../colours';

type Props = {
  heading: string,
  magentaStyle?: boolean,
  figures: Array<{ title: string, amount: number }>,
  next: () => void,
  startingTotal: number,
  negativeZero?: boolean,
};

type State = {
  displayFigures: Array<number>,
  buttonOpacity: number,
};

export default class AdditionPanel extends Component<Props, State> {
  static defaultProps = {
    magentaStyle: false,
    startingTotal: 0,
    negativeZero: false,
  };

  constructor(props: Props) {
    super(props);
    this.state = this.getInitialState(props);
  }

  getInitialState(props: Props) {
    return {
      displayFigures: props.figures.map(() => 0),
      buttonOpacity: 0,
    };
  }

  componentDidMount() {
    this.animate();
  }

  animate() {
    const { figures } = this.props;

    (async () => {
      await Bluebird.mapSeries(figures, async ({ amount, title }, i) => {
        if (amount !== 0) await Bluebird.delay(500);

        await animate(
          (elapsedProportion) => {
            const displayFigures = [...this.state.displayFigures];
            displayFigures[i] = amount * elapsedProportion;
            this.setState({ displayFigures });
          },
          { duration: amount !== 0 ? 1000 : 0 },
        );
      });

      await Bluebird.delay(500);

      await animate(
        (elapsed) => {
          this.setState({ buttonOpacity: elapsed });
        },
        { duration: 500 },
      );
    })();
  }

  props: Props;

  render() {
    const { heading, magentaStyle, figures, next, startingTotal, negativeZero } = this.props;
    const { displayFigures, buttonOpacity } = this.state;
    const displayTotal = displayFigures.reduce((acc, num) => acc + num, startingTotal);

    const highlightColour = magentaStyle ? colours.magenta : colours.blue;

    return (
      <Panel
        heading={heading}
        magentaStyle={magentaStyle}
        next={next}
        buttonOpacity={buttonOpacity}
      >
        <div className="addition">
          <div className="main-figure">{formatDollars(displayTotal)}</div>

          {figures.map(({ title }, i) => (
            <div className="constituent-figure" key={title}>
              {
                <div className="constituent-figure">{`${formatDollars(
                  displayFigures[i],
                  true,
                  false,
                  negativeZero,
                )} ${title}`}</div>
              }
            </div>
          ))}
        </div>
        <style jsx>{`
          .addition {
            text-align: left;
            min-width: 260px;
            margin-bottom: 40px;
          }

          .main-figure {
            font: 600 84px MetricWeb, sans-serif !important;
            margin: 20px 0;
            letter-spacing: 0.05em;
          }

          .main-figure:after {
            content: '';
            display: block;
            height: 5px;
            width: 60px;
            background: ${highlightColour};
            margin: 40px 0 30px;
          }

          .constituent-figure {
            font: 400 20px MetricWeb, sans-serif;
            color: ${highlightColour};
            margin-bottom: 15px;
          }
        `}</style>
      </Panel>
    );
  }
}

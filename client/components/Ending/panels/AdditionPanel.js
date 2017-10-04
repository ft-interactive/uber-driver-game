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
      await Bluebird.mapSeries(figures, async ({ amount }, i) => {
        await Bluebird.delay(500);

        await animate(
          (elapsedProportion) => {
            const displayFigures = [...this.state.displayFigures];
            displayFigures[i] = amount * elapsedProportion;
            this.setState({ displayFigures });
          },
          // { duration: 0 },
        );
      });

      await Bluebird.delay(500);

      await animate(
        (elapsed) => {
          this.setState({ buttonOpacity: elapsed });
        },
        // { duration: 0 },
      );
    })();
  }

  props: Props;

  render() {
    const { heading, magentaStyle, figures, next, startingTotal } = this.props;
    const { displayFigures, buttonOpacity } = this.state;
    const displayTotal = displayFigures.reduce((acc, num) => acc + num, startingTotal);

    return (
      <Panel
        heading={heading}
        magentaStyle={magentaStyle}
        next={next}
        buttonOpacity={buttonOpacity}
      >
        <div className="main-figure">{formatDollars(displayTotal)}</div>

        {figures.map(({ title }, i) => (
          <div className="constituent-figure" key={title}>
            {
              <div className="constituent-figure">{`${formatDollars(
                displayFigures[i],
                true,
                false,
                true,
              )} ${title}`}</div>
            }
          </div>
        ))}

        <style jsx>{`
          .main-figure {
            font: 700 50px MetricWeb, sans-serif;
          }

          .constituent-figure {
            font: 400 24px MetricWeb, sans-serif;
          }
        `}</style>
      </Panel>
    );
  }
}

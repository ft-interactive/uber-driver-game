/**
 * This is used for both the 'income' and 'costs' panels, which both add/subtract several values one
 * by one to modify the player's net total, which is displayed in big text at the top.
 */

// @flow

import React, { Component } from 'react';
import Bluebird from 'bluebird';
import easeQuintOut from 'eases/quint-out';
import Panel from './Panel';
import formatDollars from '../../../lib/formatDollars';
import animate from '../../../lib/animate';
import * as colours from '../colours';

type Props = {
  heading: string,
  magentaStyle?: boolean,
  figures: Array<{ title: string, amount: number, tooltip?: string }>,
  next: () => void,
  startingTotal: number,
  negativeZero?: boolean,
};

type State = {
  displayFigures: Array<number>,
  buttonOpacity: number,
  tooltipVisible: null | number,
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
      tooltipVisible: null,
    };
  }

  componentDidMount() {
    const { figures } = this.props;

    (async () => {
      await Bluebird.mapSeries(figures, async ({ amount }, i) => {
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
        { duration: 500, ease: easeQuintOut },
      );
    })();
  }

  props: Props;

  render() {
    const { heading, magentaStyle, figures, next, startingTotal, negativeZero } = this.props;
    const { displayFigures, buttonOpacity, tooltipVisible } = this.state;
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
          <div className="total">{formatDollars(displayTotal)}</div>

          {figures.map(({ title, tooltip }, i) => (
            <div className="item" key={title}>
              {
                <div className="item">
                  {`${formatDollars(displayFigures[i], true, false, negativeZero)} ${title}`}
                  {tooltip ? (
                    <span className="tooltip-container">
                      {tooltipVisible === i ? (
                        <span
                          className="tooltip-text"
                          role="button"
                          tabIndex={0}
                          onClick={() => {
                            this.setState({ tooltipVisible: null });
                          }}
                        >
                          {tooltip}
                        </span>
                      ) : (
                        <span
                          className="tooltip-button"
                          role="button"
                          tabIndex={0}
                          onClick={() => {
                            this.setState({ tooltipVisible: i });
                          }}
                        >
                          ?
                        </span>
                      )}
                    </span>
                  ) : null}
                </div>
              }
            </div>
          ))}
        </div>
        <style jsx>{`
          .addition {
            text-align: left;
            min-width: 260px;
            margin-bottom: 10px;
          }

          .total {
            font: 600 84px MetricWeb, sans-serif !important;
            margin: 20px 0 0;
            letter-spacing: 0.05em;
          }

          .total:after {
            content: '';
            display: block;
            height: 5px;
            width: 60px;
            background: ${highlightColour};
            margin: 20px 0 30px;
          }

          @media (min-width: 740px) {
            .addition {
              margin-bottom: 40px;
            }

            .total {
              margin: 20px 0;
            }

            .total:after {
              margin: 40px 0 30px;
            }
          }

          .item {
            font: 400 20px MetricWeb, sans-serif;
            color: ${highlightColour};
            margin-bottom: 15px;
            height: 25px;
          }

          .tooltip-container {
            display: inline-block;
            height: 0;
            width: 0;
            position: relative;
            top: -20px;
            left: 10px;
          }

          .tooltip-button {
            display: inline-block;
            position: absolute;
            color: white;
            border: 2px solid white;
            border-radius: 100%;
            width: 30px;
            height: 30px;
            overflow: hidden;
            cursor: pointer;
            text-align: center;
            line-height: 25px;
            opacity: 0.7;
          }

          .tooltip-text {
            position: absolute;
            background: white;
            width: 130px;
            font-size: 14px;
            color: black;
            opacity: 0.9;
            padding: 3px 5px;
          }

          .tooltip-button:hover {
            opacity: 1;
          }
        `}</style>
      </Panel>
    );
  }
}

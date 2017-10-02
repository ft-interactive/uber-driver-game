// @flow

import React, { Component } from 'react';
import Panel from './Panel';
import formatDollars from '../formatDollars';

type Props = {
  heading: string,
  magentaStyle?: boolean,
  figures: Array<{ title: string, amount: number }>,
  next: () => void,
  startingTotal: number,
};

export default class MathsPanel extends Component<Props> {
  static defaultProps = {
    magentaStyle: false,
    startingTotal: 0,
  };

  props: Props;

  render() {
    const { heading, magentaStyle, figures, next, startingTotal } = this.props;
    const total = figures.reduce((acc, figure) => acc + figure.amount, startingTotal);

    return (
      <Panel heading={heading} magentaStyle={magentaStyle} next={next}>
        <div className="main-figure">{formatDollars(total)}</div>

        {figures.map(({ title, amount }) => (
          <div className="constituent-figure">
            {<div className="constituent-figure">{`${formatDollars(amount, true)} ${title}`}</div>}
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

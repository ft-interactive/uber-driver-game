// @flow

import React, { Component } from 'react';
import Panel from './Panel';

type Props = {
  hoursDriven: number,
  ridesCompleted: number,
  driverRating: number,
  next: () => void,
};

export default class StatsPanel extends Component<Props> {
  props: Props;

  render() {
    const { hoursDriven, ridesCompleted, driverRating, next } = this.props;

    return (
      <Panel heading="Your stats" next={next}>
        <div className="stat">
          <h2>Hours driven</h2>
          <div>{hoursDriven}</div>
        </div>

        <div className="stat">
          <h2>Rides completed</h2>
          <div>{ridesCompleted}</div>
        </div>

        <div className="stat">
          <h2>Driver rating</h2>
          <div>{driverRating}</div>
        </div>

        <style jsx>{`
          .stat {
            margin-top: 40px;
          }
          .stat > h2 {
            color: white;
            font: 700 18px MetricWeb, sans-serif;
            margin: 0 0 10px;
          }
          .stat > div {
            color: white;
            font: 700 48px MetricWeb, sans-serif;
          }
        `}</style>
      </Panel>
    );
  }
}

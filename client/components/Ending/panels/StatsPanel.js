// @flow

import React, { Component } from 'react';
import Bluebird from 'bluebird';
import Panel from './Panel';
import animate from '../../../lib/animate';

// eslint-disable-next-line no-confusing-arrow
const ease = (t: number) =>
  // eslint-disable-next-line no-mixed-operators
  t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1;

type AllValues = {
  /* eslint-disable react/no-unused-prop-types */
  hoursDriven: number,
  ridesCompleted: number,
  driverRating: number,
  /* eslint-enable react/no-unused-prop-types */
};

type Props = AllValues & {
  next: () => void,
};

type State = {
  displayValues: AllValues,
  opacities: AllValues,
};

export default class StatsPanel extends Component<Props, State> {
  state = {
    displayValues: {
      hoursDriven: 0,
      ridesCompleted: 0,
      driverRating: 0,
    },
    opacities: {
      hoursDriven: 0,
      ridesCompleted: 0,
      driverRating: 0,
    },
  };

  componentDidMount() {
    /* eslint-disable no-await-in-loop */
    (async () => {
      // eslint-disable-next-line no-restricted-syntax
      for (const statName of ['hoursDriven', 'ridesCompleted', 'driverRating']) {
        await animate(
          (elapsed) => {
            this.setState({
              displayValues: {
                ...this.state.displayValues,
                [statName]: elapsed * this.props[statName],
              },
            });
          },
          { duration: 700 },
        );

        await Bluebird.delay(200);
      }
    })();
    /* eslint-enable no-await-in-loop */
  }

  props: Props;

  render() {
    const { next } = this.props;
    const { displayValues } = this.state;

    const items = [
      {
        title: 'Hours driven',
        value: displayValues.hoursDriven,
      },
      {
        title: 'Rides completed',
        value: displayValues.ridesCompleted,
      },
      {
        title: 'Driver rating',
        value: displayValues.driverRating,
      },
    ];

    return (
      <Panel heading="Your stats" next={next}>
        {items.map(({ title, value }) => (
          <div className="stat" key={title}>
            <h2>{title}</h2>
            <div>
              {title === 'Driver rating' ? Math.round(value * 100) / 100 : Math.round(value)}
            </div>
          </div>
        ))}

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

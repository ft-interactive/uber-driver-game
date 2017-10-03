// @flow

import React, { Component } from 'react';
import Bluebird from 'bluebird';
import Panel from './Panel';
import animate from '../../../lib/animate';

// eslint-disable-next-line no-confusing-arrow
const ease = (t: number) => (t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1);

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
  verticalOffsets: AllValues,
  onButtonClick: null | (() => void),
};

const statNames = ['hoursDriven', 'ridesCompleted', 'driverRating'];

export default class StatsPanel extends Component<Props, State> {
  state = {
    onButtonClick: null,
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
    verticalOffsets: {
      hoursDriven: 0,
      ridesCompleted: 0,
      driverRating: 0,
    },
  };

  componentDidMount() {
    (async () => {
      // animate them appearing
      await Bluebird.map(statNames, async (statName, i) => {
        const duration = 500;
        const delay = i * 300;
        await Promise.all([
          animate(
            (elapsed) => {
              this.setState({
                opacities: {
                  ...this.state.opacities,
                  [statName]: elapsed,
                },
              });
            },
            { duration, delay },
          ),
          animate(
            (elapsed) => {
              this.setState({
                verticalOffsets: {
                  ...this.state.verticalOffsets,
                  [statName]: 30 - 30 * elapsed,
                },
              });
            },
            { duration, delay, ease },
          ),
        ]);

        // TODO show the star icon, animated
      });

      // pause a moment
      await Bluebird.delay(300);

      // animate all the numbers ticking up
      await Bluebird.map(statNames, async (statName, i) => {
        const gap = 200;
        const duration = 650;
        const delay = i * (650 + gap);

        await animate(
          (elapsed) => {
            this.setState({
              displayValues: {
                ...this.state.displayValues,
                [statName]: elapsed * this.props[statName],
              },
            });
          },
          { duration, delay },
        );
      });

      // enable the 'next' button
      this.setState({
        onButtonClick: () => {
          (async () => {
            // TODO animate them away
            this.props.next();
          })();
        },
      });
    })();
  }

  props: Props;

  render() {
    // const { next } = this.props;
    const { displayValues, opacities, verticalOffsets, onButtonClick } = this.state;

    const items = [
      {
        key: 'hoursDriven',
        title: 'Hours driven',
        value: displayValues.hoursDriven,
      },
      {
        key: 'ridesCompleted',
        title: 'Rides completed',
        value: displayValues.ridesCompleted,
      },
      {
        key: 'driverRating',
        title: 'Driver rating',
        value: displayValues.driverRating,
      },
    ];

    return (
      <Panel heading="Your stats" next={onButtonClick}>
        {items.map(({ title, value, key }) => (
          <div
            className="stat"
            key={key}
            style={{
              opacity: opacities[key],
              transform: `translateY(${verticalOffsets[key]}px)`,
            }}
          >
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

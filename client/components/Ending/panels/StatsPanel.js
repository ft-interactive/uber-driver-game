// @flow

import React, { Component } from 'react';
import Bluebird from 'bluebird';
import easeQuintInOut from 'eases/quint-in-out';
import easeQuintOut from 'eases/quint-out';
import Panel from './Panel';
import animate from '../../../lib/animate';

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
  buttonOpacity: number,
};

const statNames = ['hoursDriven', 'ridesCompleted', 'driverRating'];

export default class StatsPanel extends Component<Props, State> {
  state = {
    buttonOpacity: 0,
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
        const baseDuration = 500;
        const duration = baseDuration - i * 100;
        const delay = i * duration - 50;

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
            { duration, delay, ease: easeQuintOut },
          ),
        ]);

        // TODO show the star icon, animated
      });

      // pause a moment
      await Bluebird.delay(300);

      // animate all the numbers ticking up
      await Bluebird.map(statNames, async (statName, i) => {
        const baseDuration = 650;
        const duration = i * 250 + baseDuration;
        const delay = i * (duration + 200);

        await animate(
          (elapsed) => {
            this.setState({
              displayValues: {
                ...this.state.displayValues,
                [statName]: elapsed * this.props[statName],
              },
            });
          },
          { duration, delay, ease: easeQuintInOut },
        );
      });

      await Bluebird.delay(300);

      // unhide the 'next' button TODO using buttonOpacity
      await animate(
        (elapsed) => {
          this.setState({ buttonOpacity: 1 * elapsed });
        },
        { duration: 300 },
      );
    })();
  }

  props: Props;

  render() {
    const { next } = this.props;
    const { displayValues, opacities, verticalOffsets, buttonOpacity } = this.state;

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
      <Panel heading="Your stats" next={next} buttonOpacity={buttonOpacity}>
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

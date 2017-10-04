// @flow

import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import invariant from 'invariant';
import Splash from './Splash';
import StatsPanel from './panels/StatsPanel';
import AdditionPanel from './panels/AdditionPanel';
import SummaryPanel from './panels/SummaryPanel';
import YourChoicesPanel from './panels/YourChoicesPanel';
import CreditsPanel from './panels/CreditsPanel';
import StateUtils from '../../StateUtils';
import formatDollars from '../../lib/formatDollars';
import gaAnalytics from '../analytics';

type Props = {
  stateUtils: StateUtils,
};

type Results = {
  hoursDriven: number,
  ridesCompleted: number,
  driverRating: number,

  faresAndTips: number,
  weekendQuestBonus: number,
  weekdayQuestBonus: number,

  carRental: number,
  upgrades: number,
  fuel: number,
  trafficTickets: number,
  tax: number,

  higherIncomeThan: number,
  difficulty: 'EASY' | 'HARD',
};

type SectionName =
  | 'before-start' // causes whole panel to be hidden
  | 'splash' // special panel that animates and then automatically moves to next section
  | 'stats'
  | 'income'
  | 'costs'
  | 'total-income-summary'
  | 'hourly-rate-summary'
  | 'choices'
  | 'credits';

type State = {
  currentSection: SectionName,
  results: Results | null,
  incomeSummaryImage: null | string,
  hourlyRateSummaryImage: null | string,
};

export default class Ending extends Component<Props, State> {
  static createIn(container, stateUtils) {
    let component;
    ReactDOM.render(
      <Ending
        stateUtils={stateUtils}
        ref={(_component) => {
          component = _component;
        }}
      />,
      container,
    );
    return component;
  }

  state = {
    currentSection: 'before-start',
    results: null,
    incomeSummaryImage: null,
    hourlyRateSummaryImage: null,
  };

  show(results: Results) {
    this.setState({ currentSection: 'splash', results });
    // this.setState({ currentSection: 'total-income-summary', results });
  }

  render() {
    const { stateUtils } = this.props;
    const { currentSection, results } = this.state;

    const go = (section: SectionName) => () => {
      this.setState({ currentSection: section });
      gaAnalytics('uber-game', 'scroll-end', section);
    };

    return (
      <div
        className="ending"
        style={currentSection === 'before-start' ? { display: 'none' } : null}
      >
        {(() => {
          switch (currentSection) {
            case 'before-start':
              return null;

            case 'splash':
              return <Splash onAnimationComplete={go('stats')} />;

            default: {
              invariant(results, 'Results must be defined');

              const netIncome =
                results.faresAndTips +
                results.weekdayQuestBonus +
                results.weekendQuestBonus -
                (results.carRental +
                  results.upgrades +
                  results.fuel +
                  results.trafficTickets +
                  results.tax);

              const hourlyRate = netIncome / results.hoursDriven;
              const goodNetIncome = netIncome >= 1000;
              const goodHourlyRate = hourlyRate >= 12;

              // decide on circular images
              const incomeSummaryImageURL =
                stateUtils.config.endingImages[goodNetIncome ? 'happy' : 'sad'];
              const hourlyRateSummaryImageURL =
                stateUtils.config.endingImages[goodHourlyRate ? 'happy' : 'sad'];

              // start loading ending images, and update our state when done
              const incomeSummaryImagePromise = stateUtils.loadImage(incomeSummaryImageURL, true);
              const hourlyRateImagePromise = stateUtils.loadImage(hourlyRateSummaryImageURL, true);

              // DEBUGGING
              // console.log(
              //   `goodNetIncome: ${String(goodNetIncome)}, goodHourlyRate: ${String(
              //     goodHourlyRate,
              //   )}`,
              // );
              // console.log(
              //   `incomeSummaryImageURL: ${incomeSummaryImageURL}, hourlyRateSummaryImageURL: ${hourlyRateSummaryImageURL}`,
              // );
              // console.log(
              //   'promises are same?',
              //   incomeSummaryImagePromise === hourlyRateImagePromise,
              //   hourlyRateImagePromise,
              // );
              //
              // Promise.all([incomeSummaryImagePromise, hourlyRateImagePromise]).then(([a, b]) => {
              //   console.log('blobs are same?', a === b);
              //   console.log(
              //     'blob urls are same?',
              //     URL.createObjectURL(a) === URL.createObjectURL(b),
              //     URL.createObjectURL(a),
              //     URL.createObjectURL(b),
              //   );
              // });

              switch (currentSection) {
                case 'stats':
                  return (
                    <StatsPanel
                      hoursDriven={results.hoursDriven}
                      ridesCompleted={results.ridesCompleted}
                      driverRating={results.driverRating}
                      next={go('income')}
                    />
                  );

                case 'income':
                  return (
                    <AdditionPanel
                      heading="Your income"
                      figures={[
                        { amount: results.faresAndTips, title: 'Fares and tips' },
                        { amount: results.weekendQuestBonus, title: 'Weekend quest bonus' },
                        { amount: results.weekdayQuestBonus, title: 'Weekday quest bonus' },
                      ]}
                      next={go('costs')}
                    />
                  );

                case 'costs':
                  return (
                    <AdditionPanel
                      heading="Your costs"
                      magentaStyle
                      startingTotal={
                        results.faresAndTips + results.weekendQuestBonus + results.weekdayQuestBonus
                      }
                      figures={[
                        { amount: results.carRental, title: 'Car rental' },
                        { amount: results.upgrades, title: 'Upgrades' },
                        { amount: results.fuel, title: 'Fuel' },
                        { amount: results.trafficTickets, title: 'Traffic tickets' },
                        { amount: results.tax, title: 'Tax' },
                      ]}
                      next={go('total-income-summary')}
                    />
                  );

                case 'total-income-summary':
                  return (
                    <SummaryPanel
                      imagePromise={incomeSummaryImagePromise}
                      heading={
                        goodNetIncome
                          ? `Congrats! You earned ${formatDollars(netIncome)}!`
                          : `Sorry! You only earned ${formatDollars(netIncome)}!`
                      }
                      detail={
                        goodNetIncome
                          ? `You made enough to pay your $1,000 mortgage bill. You also earned more money than ${results.higherIncomeThan}% of other players.`
                          : `You weren’t able to make enough money to pay your $1,000 mortgage bill. But you did earn more than ${results.higherIncomeThan}% of other players on ${results.difficulty}.`
                      }
                      next={go('hourly-rate-summary')}
                    />
                  );

                case 'hourly-rate-summary':
                  return (
                    <SummaryPanel
                      imagePromise={hourlyRateImagePromise}
                      heading={`You made ${formatDollars(hourlyRate, false, true)} an hour`}
                      detail={
                        goodHourlyRate
                          ? 'Your working hours meant that you earned more than the $12 minimum hourly wage in California. Well done!'
                          : 'The long hours you worked meant that you earned less than the $12 minimum hourly wage in California.'
                      }
                      next={go('choices')}
                    />
                  );

                case 'choices':
                  return (
                    <YourChoicesPanel
                      choices={[
                        {
                          text: 'You didn\'t take a single day off',
                          note: 'XX% of other players also didn\'t',
                        },
                        {
                          text: 'You kept your promise to help your son with his homework',
                          note: 'XX% of other players also did',
                        },
                        {
                          text: 'You were a good citizen and bought a business licence',
                          note: 'XX% of other players also did',
                        },
                      ]}
                      next={go('credits')}
                    />
                  );

                case 'credits':
                  return <CreditsPanel heading="End credits (TODO)" />;

                default:
                  throw new Error(`Unknown section: ${currentSection}`);
              }
            }
          }
        })()}

        <style jsx>{`
          .ending {
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
          }
        `}</style>
      </div>
    );
  }
}

// @flow

import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import Bluebird from 'bluebird';
import invariant from 'invariant';
import Splash from './Splash';
import StatsPanel from './panels/StatsPanel';
import AdditionPanel from './panels/AdditionPanel';
import AdditionPanelHack from './panels/AdditionPanelHack';
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
  netIncome: number,

  hoursDriven: number,
  ridesCompleted: number,
  driverRating: number,

  faresAndTips: number,
  weekendQuestBonus: number,
  weekdayQuestBonus: number,
  uberXLBonus: number,

  carRental: number,
  upgrades: number,
  fuel: number,
  trafficTickets: number,
  tax: number,
  repairCost: number,

  rankPromise: Bluebird<number | null>,
  difficulty: 'EASY' | 'HARD',

  tookDayOff: boolean,
  othersTookDayOff: null | number,
  helpedWithHomework: boolean,
  othersHelpedWithHomework: null | number,
  boughtBusinessLicence: boolean,
  othersBoughtBusinessLicence: null | number,
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
  static createIn(container, { stateUtils }) {
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
    // make it possible to jump straight into a given panel using e.g. `?end=total-income-summary`
    const jumpTo = new URL(location.href).searchParams.get('end');

    // $FlowFixMe
    this.setState({ currentSection: jumpTo || 'splash', results });
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

              const hourlyRate = results.netIncome / results.hoursDriven;
              const goodNetIncome = results.netIncome >= 1000;
              const goodHourlyRate = hourlyRate >= 10.5;

              // decide on circular images
              const incomeSummaryImageURL =
                stateUtils.config.endingImages[goodNetIncome ? 'happy' : 'sad'];
              const hourlyRateSummaryImageURL =
                stateUtils.config.endingImages[goodHourlyRate ? 'happy' : 'sad'];

              // start loading ending images, and update our state when done
              const incomeSummaryImagePromise = stateUtils.loadImage(incomeSummaryImageURL, true);
              const hourlyRateImagePromise = stateUtils.loadImage(hourlyRateSummaryImageURL, true);

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
                        { amount: results.weekdayQuestBonus, title: 'Weekday quest bonus' },
                        { amount: results.weekendQuestBonus, title: 'Weekend quest bonus' },
                        { amount: results.uberXLBonus, title: 'UberXL bonus' },
                      ]}
                      next={go('costs')}
                    />
                  );

                case 'costs':
                  return (
                    <AdditionPanelHack
                      heading="Minus costs"
                      magentaStyle
                      negativeZero
                      startingTotal={
                        results.faresAndTips +
                        results.weekdayQuestBonus +
                        results.weekendQuestBonus +
                        results.uberXLBonus
                      }
                      figures={[
                        { amount: results.carRental, title: 'Car rental' },
                        { amount: results.upgrades, title: 'Upgrades' },
                        { amount: results.fuel, title: 'Fuel' },
                        { amount: results.trafficTickets, title: 'Traffic tickets' },
                        { amount: results.repairCost, title: 'Repair costs' },
                        { amount: results.tax, title: 'Business tax' },
                      ]}
                      next={go('total-income-summary')}
                    />
                  );

                case 'total-income-summary': {
                  const rank = results.rankPromise.isFulfilled()
                    ? Math.round(results.rankPromise.value() * 100)
                    : null;

                  return (
                    <SummaryPanel
                      imagePromise={incomeSummaryImagePromise}
                      heading={
                        goodNetIncome
                          ? `Congrats! You earned ${formatDollars(results.netIncome)}!`
                          : `Sorry! You only earned ${formatDollars(results.netIncome)}!`
                      }
                      detail={
                        goodNetIncome
                          ? `You made enough to pay your $1,000 mortgage bill.${rank
                            ? ` You also earned more money than ${rank}% of other players on ${results.difficulty} mode.`
                            : ''}`
                          : `You weren’t able to make enough money to pay your $1,000 mortgage bill${rank
                            ? ` But you did earn more money than ${rank}% of other players on ${results.difficulty} mode.`
                            : ''}`
                      }
                      next={go('hourly-rate-summary')}
                    />
                  );
                }
                case 'hourly-rate-summary':
                  return (
                    <SummaryPanel
                      imagePromise={hourlyRateImagePromise}
                      heading={`You made ${formatDollars(hourlyRate, false, true)} an hour`}
                      detail={
                        goodHourlyRate
                          ? 'Your working hours meant that you earned more than the $10.50 minimum hourly wage in California. Well done!'
                          : 'The long hours you worked meant that you earned less than the $10.50 minimum hourly wage in California.'
                      }
                      next={go('choices')}
                    />
                  );

                case 'choices': {
                  const dayOffChoice = {};
                  if (results.tookDayOff) {
                    dayOffChoice.text = 'You took a day off.';
                    dayOffChoice.note =
                      results.othersTookDayOff !== null
                        ? `${Math.round(results.othersTookDayOff)}% of other players did the same.`
                        : null;
                  } else {
                    dayOffChoice.text = 'You took no days off.';
                    dayOffChoice.note =
                      results.othersTookDayOff !== null
                        ? `${Math.round(
                          100 - results.othersTookDayOff,
                        )}% of other players did the same.`
                        : null;
                  }

                  const helpedWithHomeworkChoice = {};
                  if (results.helpedWithHomework) {
                    helpedWithHomeworkChoice.text = 'You helped your son with his homework.';
                    helpedWithHomeworkChoice.note =
                      results.othersHelpedWithHomework !== null
                        ? `${Math.round(
                          results.othersHelpedWithHomework,
                        )}% of other players did the same.`
                        : null;
                  } else {
                    helpedWithHomeworkChoice.text = 'You didn’t help your son with his homework.';
                    helpedWithHomeworkChoice.note =
                      results.othersHelpedWithHomework !== null
                        ? `${Math.round(
                          100 - results.othersHelpedWithHomework,
                        )}% of other players also didn’t.`
                        : null;
                  }

                  const boughtBusinessLicenceChoice = {};
                  if (results.boughtBusinessLicence) {
                    boughtBusinessLicenceChoice.text = 'You bought a business licence.';
                    boughtBusinessLicenceChoice.note =
                      results.othersBoughtBusinessLicence !== null
                        ? `${Math.round(
                          results.othersBoughtBusinessLicence,
                        )}% of other players did the same.`
                        : null;
                  } else {
                    boughtBusinessLicenceChoice.text = 'You didn’t buy a business licence.';
                    boughtBusinessLicenceChoice.note =
                      results.othersBoughtBusinessLicence !== null
                        ? `${Math.round(
                          100 - results.othersBoughtBusinessLicence,
                        )}% of other players also didn’t.`
                        : null;
                  }

                  return (
                    <YourChoicesPanel
                      choices={[
                        dayOffChoice,
                        helpedWithHomeworkChoice,
                        boughtBusinessLicenceChoice,
                      ]}
                      next={go('credits')}
                    />
                  );
                }

                case 'credits': {
                  const data = stateUtils.config.credits;

                  return (
                    <CreditsPanel
                      credits={data.people}
                      blurb={data.blurb}
                      relatedArticleURL={data.relatedArticle.url}
                      relatedArticleHeadline={data.relatedArticle.headline}
                      relatedArticleImageURL={stateUtils.getImageServiceURL(
                        data.relatedArticle.imageURL,
                        false,
                        400,
                      )}
                    />
                  );
                }
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

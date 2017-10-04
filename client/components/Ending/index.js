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

type Props = {};

type Results = {
  hoursDriven: number,
  ridesCompleted: number,
  driverRating: number,
  income: number,

  faresAndTips: number,
  weekendQuestBonus: number,
  weekdayQuestBonus: number,

  carRental: number,
  upgrades: number,
  fuel: number,
  trafficTickets: number,
  tax: number,
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
};

export default class Ending extends Component<Props, State> {
  static createIn(container) {
    let component;
    ReactDOM.render(
      <Ending
        ref={(_component) => {
          component = _component;
        }}
      />,
      container,
    );
    return component;
  }

  constructor() {
    super();

    this.state = {
      currentSection: 'before-start',
      results: null,
    };
  }

  show(results: Results) {
    this.setState({ currentSection: 'splash', results });
  }

  render() {
    const { currentSection, results } = this.state;

    const go = (section: SectionName) => () => {
      this.setState({ currentSection: section });
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

            default:
              invariant(results, 'Results must be defined');

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
                      heading={'Congrats! You made xxxxx!'}
                      detail={
                        "You reached your goal blah blah that's more than X% of other players blah blah blah"
                      }
                      next={go('hourly-rate-summary')}
                    />
                  );

                case 'hourly-rate-summary':
                  return (
                    <SummaryPanel
                      heading={'...but your hourly rate was $2'}
                      detail={"That's really low and stuff"}
                      next={go('choices')}
                    />
                  );

                case 'choices':
                  return (
                    <YourChoicesPanel
                      choices={[
                        {
                          text: 'You didnt take a single day off',
                          note: 'XX% of other players also didnt',
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

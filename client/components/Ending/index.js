// @flow

import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import invariant from 'invariant';
import Splash from './Splash';
import Panel from './panels/Panel';
import StatsPanel from './panels/StatsPanel';

type Props = {};

type Results = {
  hoursDriven: number,
  ridesCompleted: number,
  driverRating: number,
  income: number,
  faresAndTips: number,
  weekendQuestBonus: number,
  weekdayQuestBonus: number,
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
    ReactDOM.render(<Ending ref={_component => (component = _component)} />, container);
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
                    <Panel
                      heading="Your income"
                      priceInfo={[
                        { amount: results.faresAndTips, type: 'Fares and tips' },
                        { amount: results.weekendQuestBonus, type: 'Weekend quest bonus' },
                        { amount: results.weekdayQuestBonus, type: 'Weekday quest bonus' },
                      ]}
                      next={go('costs')}
                    />
                  );

                case 'costs':
                  return <Panel heading="Costs (TODO)" next={go('total-income-summary')} />;

                case 'total-income-summary':
                  return <Panel heading="Congrats!! (TODO)" next={go('hourly-rate-summary')} />;

                case 'hourly-rate-summary':
                  return <Panel heading="But you only made... (TODO)" next={go('choices')} />;

                case 'choices':
                  return <Panel heading="Your choices (TODO)" next={go('credits')} />;

                case 'credits':
                  return <Panel heading="End credits (TODO)" />;

                default:
                  throw new Error(`Unknown section: ${currentSection}`);
              }
          }
        })()}

        <style jsx>{`
          .ending {
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
          }
        `}</style>
      </div>
    );
  }
}

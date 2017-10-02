import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import Splash from './Splash';
import InfoPanel from './InfoPanel';

export default class Ending extends Component {
  static createIn(container) {
    let component;
    ReactDOM.render(<Ending ref={_component => (component = _component)} />, container);
    return component;
  }

  constructor() {
    super();

    this.state = {
      section: 'before-start', // before-start, splash, stats, ...
    };
  }

  show(otherState) {
    this.setState({ section: 'splash', ...otherState });
  }

  render() {
    const {
      section,
      hoursDriven,
      ridesCompleted,
      driverRating,
      faresAndTips,
      weekendQuestBonus,
      weekdayQuestBonus,
    } = this.state;

    let classes = `ending ending--${section}`;
    if (section !== 'before-start') {
      classes += ' ending--visible';
    }

    return (
      <div className={classes}>
        {(() => {
          switch (section) {
            case 'splash':
              return (
                <Splash
                  onAnimationComplete={() => {
                    this.setState({ section: 'stats' });
                  }}
                />
              );

            case 'stats':
              return (
                <InfoPanel
                  title="Your stats"
                  values={{
                    'Hours driven': hoursDriven,
                    'Rides completed': ridesCompleted,
                    'Driver rating': driverRating,
                  }}
                  onClickContinue={() => {
                    this.setState({ section: 'income' });
                  }}
                />
              );

            case 'income':
              return (
                <InfoPanel
                  title="Your income"
                  priceInfo={[
                    { amount: faresAndTips, type: 'Fares and tips' },
                    { amount: weekendQuestBonus, type: 'Weekend quest bonus' },
                    { amount: weekdayQuestBonus, type: 'Weekday quest bonus' },
                  ]}
                  onClickContinue={() => {
                    this.setState({ section: 'costs' });
                  }}
                />
              );

            case 'costs':
              return (
                <InfoPanel
                  title="Costs (TODO)"
                  onClickContinue={() => {
                    this.setState({ section: 'positive-summary' });
                  }}
                />
              );

            case 'positive-summary':
              return (
                <InfoPanel
                  title="Congrats!! (TODO)"
                  onClickContinue={() => {
                    this.setState({ section: 'negative-summary' });
                  }}
                />
              );

            case 'negative-summary':
              return (
                <InfoPanel
                  title="But you only made... (TODO)"
                  onClickContinue={() => {
                    this.setState({ section: 'non-monetary-costs' });
                  }}
                />
              );

            case 'non-monetary-costs':
              return (
                <InfoPanel
                  title="Non-monetary costs (TODO)"
                  onClickContinue={() => {
                    this.setState({ section: '' });
                  }}
                />
              );

            case 'credits':
              return <InfoPanel title="End credits (tTODO)" />;

            default:
              return null;
          }
        })()}
      </div>
    );
  }
}

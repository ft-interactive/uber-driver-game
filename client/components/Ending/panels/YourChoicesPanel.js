// @flow

import React from 'react';
import Panel from './Panel';

type Props = {
  stateUtils: stateUtils;
  decisionsData: Array;
  next: () => void,
};

const YourChoicesPanel = ({ stateUtils, decisionsData, next }: Props) => {
  const choices = [
    'biz_licence',
    'helped_homework',
    'took_day_off',
  ].map((item) => {
    const outcome = stateUtils.story.variablesState.$(item);
    const did = Number(decisionsData[item].true);
    const didNot = Number(decisionsData[item].false);
    const total = did + didNot;
    const outcomePct = Math.round(outcome ? did / total * 100 : didNot / total * 100);
    const outcomeNum = outcome ? did : didNot;
    switch (item) {
      case 'biz_licence':
        return {
          text: `You ${outcome ? 'bought' : 'didn\'t buy'} a business license.`,
          note: `${outcomeNum} (${outcomePct}%)`,
        };
      case 'helped_homework':
        return {
          text: `You ${outcome ? 'helped' : 'didn\'t help'} your son with homework.`,
          note: `${outcomeNum} (${outcomePct}%)`,
        };
      case 'took_day_off':
        return {
          text: `You ${outcome ? 'took' : 'didn\'t take'} a day off.`,
          note: `${outcomeNum} (${outcomePct}%)`,
        };
      default:
        return; // eslint-disable-line
    }
  });

  return (
    <Panel next={next} heading="Your choices">
      {choices.map(({ text, note }) => (
        <div className="choice" key={text}>
          <h3>{text}</h3>
          <p><strong>{note}</strong> did the same</p>
        </div>
      ))}
      <style jsx>{`
        h3 {
          color: white;
          font: 700 32px MetricWeb, sans-serif;
          line-height: 40px;
        }

        p {
          color: white;
          font: 400 18px MetricWeb, sans-serif;
          line-height: 26px;
        }
      `}</style>
    </Panel>
  );
};


export default YourChoicesPanel;

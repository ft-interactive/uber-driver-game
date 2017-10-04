// @flow

import React from 'react';
import Panel from './Panel';

type Props = {
  choices: Array<{
    text: string,
    note: string,
  }>,
  next: () => void,
};

const YourChoicesPanel = ({ choices, next }: Props) => (
  <Panel next={next} heading="Your choices">
    {choices.map(({ text, note }) => (
      <div className="choice" key={text}>
        <h3>{text}</h3>
        <p>{note}</p>
      </div>
    ))}
    <style jsx>{`
      h3 {
        color: white;
        max-width: 580px;
        margin: .3em 0 .8em;
        font-family: MetricWeb, sans-serif;
        font-size: 24px;
        font-weight: 600;
        line-height: 28px;
      }

      p {
        color: white;
        max-width: 580px;
        margin: .3em 0 .8em;
        font-family: MetricWeb, sans-serif;
        font-size: 18px;
        line-height: 1.4;
        text-align: center;
      }
    `}</style>
  </Panel>
);

export default YourChoicesPanel;
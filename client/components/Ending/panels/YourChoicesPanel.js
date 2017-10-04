// @flow

import React from 'react';
import Panel from './Panel';

type Props = {
  next: () => void,
  choices: {
    text: string,
    note: string | null,
  }[],
};

const YourChoicesPanel = ({ next, choices }: Props) => (
  <Panel next={next} heading="Your choices">
    {choices.map(({ text, note }) => (
      <div className="choice" key={text}>
        <h3>{text}</h3>
        {note ? <p>{note}</p> : null}
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

export default YourChoicesPanel;

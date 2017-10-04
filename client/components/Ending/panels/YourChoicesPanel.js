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
      <div className="choice">
        <h3>{text}</h3>
        <p>{note}</p>
      </div>
    ))}
    <style jsx>{`
      h1 {
        color: white;
      }

      p {
        color: white;
      }
    `}</style>
  </Panel>
);

export default YourChoicesPanel;

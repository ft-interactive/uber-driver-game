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
    <div className="choices">
      {choices.map(({ text, note }) => (
        <div className="choice" key={text}>
          <h3>{text}</h3>
          {note ? <p>{note}</p> : null}
        </div>
      ))}
    </div>
    <style jsx>{`
      .choices {
        margin-bottom: 40px;
        padding: 0 30px;
      }

      .choice {
        margin: 20px 0;
      }
      h3 {
        color: white;
        max-width: 580px;
        margin: 0.3em 0 0;
        font-family: MetricWeb, sans-serif;
        font-size: 24px;
        font-weight: 600;
        line-height: 28px;
      }

      p {
        color: white;
        max-width: 580px;
        margin: 0;
        font-family: MetricWeb, sans-serif;
        font-size: 18px;
        line-height: 1.4;
        text-align: center;
      }
    `}</style>
  </Panel>
);

export default YourChoicesPanel;

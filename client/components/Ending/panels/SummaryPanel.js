// @flow

import React from 'react';
import Panel from './Panel';

type Props = {
  heading: string,
  detail: string,
  next: () => void,
};

const SummaryPanel = ({ heading, detail, next }: Props) => (
  <Panel next={next}>
    <h1>{heading}</h1>
    <p>{detail}</p>
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

export default SummaryPanel;

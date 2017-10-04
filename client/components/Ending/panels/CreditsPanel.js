// @flow

import React from 'react';
import Panel from './Panel';

const CreditsPanel = () => (
  <Panel>
    <p>This game was produced by blah blah blah</p>

    <p>
      This game is based on reporting and interviews with Uber drivers. Read more about their story:
    </p>

    <article className="article-link">Uber loses licence to operate in London</article>

    <p>Share this game:</p>

    <div className="share-links">origami share links TKTK</div>

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

export default CreditsPanel;

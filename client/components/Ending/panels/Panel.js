// @flow

import React, { Component } from 'react';
import type { Element } from 'react';
import * as colours from '../colours';

type Props = {
  heading?: string,
  magentaStyle?: boolean,
  next?: null | (() => void),
  children: Element<any> | Element<any>[],
};

export default class Panel extends Component<Props> {
  static props: Props;

  static defaultProps = {
    heading: null,
    next: null,
    magentaStyle: false,
  };

  render() {
    const { heading, next, magentaStyle, children } = this.props;

    const highlightColour = magentaStyle ? colours.magenta : colours.blue;

    return (
      <div className="panel">
        {heading && (
          <header className="heading">
            <div className="heading-rule" />
            <h1>{heading}</h1>
            <div className="heading-rule" />
          </header>
        )}

        <div className="content">{children}</div>

        {next && (
          <button onClick={next}>
            <i className="material-icons">keyboard_arrow_down</i>
            <span>Continue</span>
          </button>
        )}

        <style jsx>{`
          .panel {
            width: 100%;
            height: 100%;
            background: ${colours.darkGrey};
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
          }

          .heading {
            display: flex;
            justify-content: center;
          }

          .heading > h1 {
            color: ${highlightColour};
            text-transform: uppercase;
            font: 300 34px MetricWeb, sans-serif;
            margin: -18px 18px 0;
          }

          .heading-rule {
            width: 80px;
            height: 2px;
            background: ${highlightColour};
          }

          button {
            display: block;
            margin-top: 40px;
            background: ${highlightColour};
            width: 50px;
            height: 50px;
            border: 0;
            text-align: center;
          }

          button > i.material-icons {
            font-size: 32px;
            color: ${colours.darkGrey};
            margin-top: 5px;
          }

          button > span {
            position: absolute;
            overflow: hidden;
            clip: rect(0 0 0 0);
            height: 1px;
            width: 1px;
            margin: -1px;
            padding: 0;
            border: 0;
          }
        `}</style>
      </div>
    );
  }
}

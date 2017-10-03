// @flow

import React, { Component } from 'react';
import type { Element } from 'react';
import * as colours from '../colours';

type NestedArray<T> = Array<T | NestedArray<T>>;
type Child = Element<any>;

type Props = {
  heading?: string,
  magentaStyle?: boolean,
  next?: null | (() => void),
  children?: null | Child | NestedArray<Child>,
  buttonOpacity?: number,
};

const HEADING_HEIGHT = 40;
const BUTTON_SIZE = 50;
const SPACE_UNDER_BUTTON = 20;

export default class Panel extends Component<Props> {
  static props: Props;

  static defaultProps = {
    heading: null,
    next: null,
    magentaStyle: false,
    children: null,
    buttonOpacity: 1,
  };

  render() {
    const { heading, next, magentaStyle, buttonOpacity, children } = this.props;

    const highlightColour = magentaStyle ? colours.magenta : colours.blue;

    return (
      <div className="panel">
        <div className="spacer" />

        <div className="inner">
          {heading && (
            <header className="heading">
              <div className="heading-rule" />
              <h1>{heading}</h1>
              <div className="heading-rule" />
            </header>
          )}

          <div className="content">{children}</div>

          {next && (
            <button onClick={next} style={{ opacity: buttonOpacity }}>
              <i className="material-icons">keyboard_arrow_down</i>
              <span>Continue</span>
            </button>
          )}
        </div>

        <div className="spacer" />

        <style jsx>{`
          .panel {
            width: 100%;
            height: 100%;
            background: ${colours.darkGrey};
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            overflow: auto;
            -webkit-overflow-scrolling: touch;
          }

          .spacer {
            flex: 1;
            min-height: 20px;
          }

          .inner {
            display: flex;
            flex-direction: column;
            align-items: center;
          }

          .heading {
            display: flex;
            justify-content: center;
            height: ${HEADING_HEIGHT}px;
            min-height: ${HEADING_HEIGHT}px;
            overflow: hidden;
            position: relative;
          }

          .heading > h1 {
            color: ${highlightColour};
            text-transform: uppercase;
            font: 300 30px MetricWeb, sans-serif;
            line-height: ${HEADING_HEIGHT}px;
            margin: 0 18px;
            white-space: nowrap;
          }

          .heading-rule {
            width: 50px;
            height: 2px;
            background: ${highlightColour};
            margin-top: ${HEADING_HEIGHT / 2 - 1}px;
          }

          .content {
            flex: 1;
          }

          button {
            display: block;
            margin: 0 0 ${SPACE_UNDER_BUTTON}px;
            background: ${highlightColour};
            width: ${BUTTON_SIZE}px;
            height: ${BUTTON_SIZE}px;
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

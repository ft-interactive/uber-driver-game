// @flow

import React, { Component } from 'react';
import Panel from './Panel';

type Props = {
  heading: string,
  detail: string,
  imagePromise: Promise<Blob>,
  next: () => void,
};

type State = {
  imageURL: null | string,
};

export default class SummaryPanel extends Component<Props, State> {
  constructor(props) {
    super(props);
    props.imagePromise.then((blob) => {
      const imageURL = URL.createObjectURL(blob);
      this.setState({ imageURL });
    });
  }

  state = {
    imageURL: null,
  };

  componentWillReceiveProps(newProps) {
    newProps.imagePromise.then((blob) => {
      const imageURL = URL.createObjectURL(blob);
      this.setState({ imageURL });
    });
  }

  render() {
    const { imageURL } = this.state;
    const { heading, detail, next } = this.props;

    return (
      <Panel next={next}>
        <div className="image-container">{imageURL ? <img alt="" src={imageURL} /> : null}</div>

        <h1>{heading}</h1>
        <p>{detail}</p>

        <style jsx>{`
          h1 {
            color: white;
            font: 700 30px MetricWeb, sans-serif;
            margin-top: 32px;
          }

          .image-container {
            position: relative;
            width: 200px;
            height: 200px;
            margin-left: auto;
            margin-right: auto;
          }

          .image-container > img {
            width: 100%;
            height: 100%;
          }

          p {
            font: 400 18px MetricWeb, sans-serif;
            line-height: 1.6em;
            color: white;
            margin: 32px 0;
          }
        `}</style>
      </Panel>
    );
  }
}

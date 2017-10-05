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
  constructor(props: Props) {
    super(props);
    props.imagePromise.then((blob) => {
      const imageURL = URL.createObjectURL(blob);
      this.setState({ imageURL });
    });
  }

  state = {
    imageURL: null,
  };

  componentWillReceiveProps(newProps: Props) {
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
        <div className="summary">
          <div className="image-container">{imageURL ? <img alt="" src={imageURL} /> : null}</div>

          <h1>{heading}</h1>
          <p>{detail}</p>
        </div>
        <style jsx>{`
          .summary {
            padding: 0 40px;
          }

          h1 {
            color: white;
            max-width: 580px;
            font-family: MetricWeb, sans-serif;
            font-size: 24px;
            font-weight: 600;
            line-height 28px;
            margin-top: 0.3em;
          }

          .image-container {
            position: relative;
            width: 200px;
            height: 200px;
            margin: 0 auto 10px;
          }

          .image-container > img {
            width: 100%;
            height: 100%;
          }

          p {
            color: white;
            max-width: 580px;
            margin: .3em 0 .8em;
            font-family: MetricWeb, sans-serif;
            font-size: 18px;
            line-height: 20px;
          }
        `}</style>
      </Panel>
    );
  }
}

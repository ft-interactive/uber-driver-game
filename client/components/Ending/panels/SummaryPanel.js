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
            max-width: 580px;
            font-family: MetricWeb, sans-serif;
            font-size: 40px;
            font-weight: 600;
            line-height 40px;
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
            line-height: 1.4;
            text-align: center;
          }
        `}</style>
      </Panel>
    );
  }
}

// @flow

import React, { Component } from 'react';
import invariant from 'invariant';
import Panel from './Panel';
import * as colours from '../colours';

type Props = {
  credits: { name: string, link?: string }[],
  blurb: string,
  relatedArticleURL: string,
  relatedArticleHeadline: string,
  relatedArticleImageURL: string,
};

export default class CreditsPanel extends Component<Props> {
  componentDidMount() {
    // dirty hack to clone the o-share from the page into this element
    if (this.shareLinksContainer) {
      const oldOShare = document.querySelector('.article__share [data-o-component="o-share"]');

      if (oldOShare) {
        const oShare = oldOShare.cloneNode(true);

        invariant(this.shareLinksContainer, 'cannot have changed');

        this.shareLinksContainer.appendChild(oShare);

        if (window.Origami) {
          const OShare = window.Origami['o-share'];
          new OShare(oShare); // eslint-disable-line no-new
        } else {
          console.warn('Origami not loaded');
        }
      }
    }
  }

  shareLinksContainer: null | HTMLDivElement;

  render() {
    const {
      credits,
      blurb,
      relatedArticleURL,
      relatedArticleHeadline,
      relatedArticleImageURL,
    } = this.props;

    return (
      <Panel>
        <div className="credits-panel">
          <p>
            The Uber Game was produced by{' '}
            <span className="people">
              {credits.map(({ name, link }, i) => {
                let append;

                if (i === credits.length - 1) append = '.';
                else if (i === credits.length - 2) append = ' and ';
                else if (i < credits.length - 2) append = ', ';

                return (
                  <span key={name}>
                    {link ? (
                      <a className="person" href={link}>
                        {name}
                      </a>
                    ) : (
                      <span className="person">{name}</span>
                    )}
                    {append}
                  </span>
                );
              })}
            </span>
          </p>

          <p className="share-text">Share this game:</p>
          <div
            className="share-links"
            ref={(el) => {
              this.shareLinksContainer = el;
            }}
          />

          <p className="blurb">{blurb}</p>

          <a className="article-link" href={relatedArticleURL}>
            <img alt="" src={relatedArticleImageURL} />
            <div>{relatedArticleHeadline}</div>
          </a>
        </div>
        <style jsx>{`
          .credits-panel {
            color: white;
            padding: 0 10px;
            max-width: 600px;
          }

          .credits-panel p {
            font-family: MetricWeb, sans-serif;
            color: white;
            font-size: 16px;
            font-weight: 400;
            line-height: 1.5;
            text-align: left;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
          }

          .credits-panel p.share-text,
          .credits-panel p.blurb {
            text-align: center;
          }

          .credits .text-style-1 {
            font-weight: normal;
          }

          .people {
            font-weight: 600;
          }

          .credits-panel .person {
            color: white;
            text-decoration: none;
            border-bottom: 0;
          }
          .credits-panel a.person:hover {
            color: ${colours.blue};
          }

          .share-links {
            margin-bottom: 10px;
          }

          .article-link {
            position: relative;
            padding: 20px 40px;
            margin-top: 50px;
            border: 2px solid ${colours.blue};
            display: inline-block;
            width: 77%;
            color: ${colours.blue};
          }

          .article-link:hover {
            color: ${colours.blue};
            border-color: ${colours.blue};
          }

          .article-link img {
            position: relative;
            top: -40px;
            width: 100%;
          }

          .article-link > div {
            font-size: 1.3em;
            margin-top: -70px;
            padding: 0 20px;
            margin: 0 auto;
          }

          @media (min-width: 740px) {
            .article-link {
              padding: 1em 2em;
              margin-top: 4em;
              display: inline-block;
              width: auto;
            }

            .article-link img {
              position: relative;
              top: -4em;
              width: auto;
            }

            .article-link article {
              font-size: 2em;
            }
          }
        `}</style>

        <style jsx global>{`
          /* this counteracts o-typography styles we don't want */

          .o-share li:before {
            content: none !important;
          }

          .o-share li {
            padding-left: 0 !important;
          }

          @media (min-width: 490px) {
            .o-share__action--whatsapp {
              display: none !important;
            }
          }
        `}</style>
      </Panel>
    );
  }
}

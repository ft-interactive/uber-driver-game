// @flow

import React, { Component } from 'react';
import invariant from 'invariant';
import Panel from './Panel';

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
            This game was produced by{' '}
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

          <p>{blurb}</p>

          <a className="article-link" href={relatedArticleURL}>
            <img alt="" src={relatedArticleImageURL} />
            <article>{relatedArticleHeadline}</article>
          </a>

          <p>Share this game:</p>
          <div
            className="share-links"
            ref={(el) => {
              this.shareLinksContainer = el;
            }}
          />
        </div>
        <style jsx>{`
          .credits-panel {
            color: white;
          }

          .credits-panel p {
            font-family: MetricWeb, sans-serif;
            color: white;
          }

          .people {
            font-weight: 700;
          }

          .person,
          .person:hover {
            color: white;
            text-decoration: none;
            border-bottom: 0;
          }

          .article-link {
            /* TODO */
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

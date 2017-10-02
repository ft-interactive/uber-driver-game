import React, { Component } from 'react';
import PropTypes from 'prop-types';

export default class InfoPanel extends Component {
  componentDidMount() {
    // do stuff
  }

  render() {
    const { title, values, onClickContinue } = this.props;

    return (
      <div className="info-panel">
        {title && (
          <header>
            <div className="info-panel__heading-rule" />
            <h1>{title}</h1>
            <div className="info-panel__heading-rule" />
          </header>
        )}

        {values &&
          Object.keys(values).map(name => (
            <div className="info-panel__statistic">
              <h2>{name}</h2>
              <div>{values[name]}</div>
            </div>
          ))}

        {onClickContinue && (
          <button className="info-panel__button" onClick={onClickContinue}>
            <i className="material-icons">keyboard_arrow_down</i>
            <span>Continue</span>
          </button>
        )}
      </div>
    );
  }
}

InfoPanel.propTypes = {
  title: PropTypes.string,
  onClickContinue: PropTypes.func,
  values: PropTypes.objectOf(PropTypes.number),
};

InfoPanel.defaultProps = {
  title: null,
  onClickContinue: null,
  values: null,
};

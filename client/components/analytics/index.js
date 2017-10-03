/* global ga */

module.exports = (eventCategory, eventAction, eventLabel, eventValue) => {
  if (!window.ga) {
    console.log('>>>>> ga event: ', { eventCategory, eventAction, eventLabel, eventValue });
    return;
  }
  //
  // ga('send', {
  //   hitType: 'event',
  //   eventCategory,
  //   eventAction,
  //   eventLabel,
  //   eventValue,
  //   transport: 'beacon',
  // });
};

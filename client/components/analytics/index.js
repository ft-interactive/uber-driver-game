/* global ga */

module.exports = (eventCategory, eventAction, eventLabel) => {
  if (!window.ga) {
    console.log('>>>>> ga event: ', { eventCategory, eventAction, eventLabel });
    return;
  }
  //
  // ga('send', {
  //   hitType: 'event',
  //   eventCategory,
  //   eventAction,
  //   eventLabel,
  //   transport: 'beacon',
  // });
};

import anime from 'animejs';
import fscreen from 'fscreen';
import { Story } from 'inkjs';
import { throttle } from 'lodash';
import moment from 'moment-timezone';
import './styles.scss';
import json from './uber.json';
import config from './config.yml';
import StateUtils from './StateUtils';
import GameContainer from './components/GameContainer';
import Ending from './components/Ending';
import Modernizr from './modernizr'; // eslint-disable-line no-unused-vars
import gaAnalytics from './components/analytics';

const endpoint =
  window.ENV === 'development'
    ? 'http://localhost:3000'
    : 'https://ft-ig-uber-game-backend.herokuapp.com';

const story = new Story(json);
const stateUtils = new StateUtils(story, config);

// Elements
const logo = document.querySelector('.logo');
const shareButtons = document.querySelector('.article__share');
const footer = document.querySelector('.o-typography-footer');
const tint = document.querySelector('.tint');
const introScreen = document.getElementById('intro');
const fullscreenButtonsElement = document.querySelector('.toggle-fullscreen');
const caveatsButton = document.getElementById('caveats-button');
const caveatsScreen = document.getElementById('caveats');
// const enterFullscreenButton = document.getElementById('enter-fullscreen-button');
// const exitFullscreenButton = document.getElementById('exit-fullscreen-button');
const startButton = document.getElementById('start-button');
const storyScreen = document.getElementById('story');
const earningsDisplay = document.getElementById('earnings');
const timeDisplay = document.getElementById('time');
const ratingDisplay = document.getElementById('rating');
const knotContainer = document.querySelector('.knot-container');
const knotElement = document.querySelector('.knot');
const knotDecoration = document.querySelector('.decoration');
const timePassingScreen = document.querySelector('.time-passing-container');
const timePassingTextHours = document.getElementById('time-passing-text__hours');
const timePassingImage = document.querySelector('.time-passing-image');
const timePassingEarnings = document.getElementById('tp-earnings');
const timePassingTime = document.getElementById('tp-time');
const timePassingDay = document.getElementById('tp-day');
const timePassingRides = document.getElementById('tp-rides');
const timePassingRideGoal = document.getElementById('tp-ride-goal');
const timePassingRideGoalTotal = document.getElementById('tp-ride-goal-total');
const timePassingButton = document.getElementById('tp-button');
const momentScreen = document.querySelector('.moment-container');
const momentText = document.getElementById('moment-text');
const momentImage = document.querySelector('.moment-image');
const momentTime = document.getElementById('moment-time');
const momentDay = document.getElementById('moment-day');
const momentRides = document.getElementById('moment-rides');
const momentRideGoal = document.getElementById('moment-ride-goal');
const momentRideGoalTotal = document.getElementById('moment-ride-goal-total');
const momentButton = document.getElementById('moment-button');

// keep list of choices made in game for analytics
const yourChoices = [];

const gameContainer = new GameContainer(document.querySelector('.game-container'), stateUtils);
gameContainer.initialise();
const ending = Ending.createIn(document.querySelector('.ending-container'), stateUtils);

let choicesContainerElement;
// Dimensions
let gutterWidth;
let headerWidth;
const logoHeight = logo.offsetHeight;
let articleBodyHeight;
let knotContainerMaxHeight;
// Needed for animations
const defaultInDuration = 300;
const defaultOutDuration = 200;
const timePassingScreenDuration = 1500;
const earningsObj = { value: 0, totalValue: 0 };
const timeObj = { value: 1502092800000 };
const ratingObj = { value: 500 };
// ridesObj.value counts for ride count during time passing screens
// ridesObj.totalValue counts total number of rides during game
const ridesObj = { value: 0, totalValue: 0 };
const questRidesObj = { value: 0 };

function handleFullscreen() {
  if (fscreen.fullscreenElement !== null) {
    console.log('Entered fullscreen mode');
  } else {
    console.log('Exited fullscreen mode');
  }
}

function handleResize() {
  const d = new Date();

  gutterWidth = window.innerWidth < 740 ? 10 : 20;
  headerWidth = document.querySelector('header').offsetWidth - 40;
  articleBodyHeight = document.querySelector('.article-body').offsetHeight;
  knotContainerMaxHeight = articleBodyHeight - logoHeight - 16;

  if (!logo.style.right) {
    logo.style.left = `${gutterWidth}px`;
  }

  knotContainer.style.maxHeight = `${knotContainerMaxHeight}px`;

  console.log(`Window resized ${d.toLocaleTimeString()}`); // eslint-disable-line no-console

  if (fscreen.fullscreenEnabled && window.outerWidth < 1024) {
    fscreen.addEventListener('fullscreenchange', handleFullscreen, false);
    fullscreenButtonsElement.style.display = 'block';

    document.addEventListener(
      'oForms.toggled',
      (event) => {
        if (event.target.checked) {
          fscreen.requestFullscreen(document.querySelector('main'));
        } else {
          fscreen.exitFullscreen();
        }
      },
      false,
    );
  } else {
    fscreen.removeEventListener('fullscreenchange', handleFullscreen);
    fullscreenButtonsElement.style.display = 'none';
  }
}

function showCaveats() {
  const showCaveatsScreen = anime.timeline();

  showCaveatsScreen
    .add({
      targets: introScreen,
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      complete: () => {
        introScreen.style.display = 'none';
        caveatsScreen.style.display = 'block';
      },
    })
    .add({
      targets: caveatsScreen,
      opacity: 1,
      duration: defaultInDuration,
      easing: 'linear',
    });

  gaAnalytics('uber-game', 'show-caveats');
}

function endStory() {
  tint.style.display = 'none';
  introScreen.style.display = 'none';
  document.querySelector('.article-head').style.display = 'none';
  storyScreen.style.display = 'none';
  document.body.classList.add('showing-ending');

  ending.show({
    // stats
    hoursDriven: story.variablesState.$('hours_driven_total'),
    ridesCompleted: story.variablesState.$('ride_count_total'),
    driverRating: story.variablesState.$('rating') / 100,

    // income
    faresAndTips: story.variablesState.$('fares_earned_total'),
    weekdayQuestBonus: story.variablesState.$('weekday_quest_bonus'),
    weekendQuestBonus: story.variablesState.$('weekend_quest_bonus'),

    // costs
    carRental: 0 - story.variablesState.$('car_cost'),
    upgrades: 0 - story.variablesState.$('accessories_cost'),
    fuel: 0 - story.variablesState.$('gas_cost'),
    trafficTickets: 0 - story.variablesState.$('ticket_cost'),
    tax: 0 - story.variablesState.$('tax_cost'),

    // total-income-summary
    higherIncomeThan: 86, // percent of other players

    // hourly-rate-summary - automatic

    // your-choices
    difficulty: 'EASY',
    tookDayOff: true,
    othersTookDayOff: 78, // per cent
    helpedWithHomework: true,
    othersHelpedWithHomework: 57, // per cent
    boughtBusinessLicense: false,
    othersBoughtBusinessLicense: 44, // per cent
  });
}

function recordDecision(decision) {
  const meta = Object.entries(story.variablesState._globalVariables).reduce((acc, [key, value]) => {
    acc[key] = value._value;
    return acc;
  }, {});

  return fetch(`${endpoint}/decisions`, {
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    method: 'POST',
    body: JSON.stringify({
      type: decision,
      value: story.variablesState.$(decision) === 1,
      difficulty: story.variablesState.$('credit_rating') === 'good' ? 'easy' : 'hard',
      meta,
    }),
  })
    .then(() => console.info(`${decision} recorded`))
    .catch(e => console.error(`Error recording: ${e}`));
}

function recordPlayerResult() {
  const meta = Object.entries(story.variablesState._globalVariables).reduce((acc, [key, value]) => {
    acc[key] = value._value;
    return acc;
  }, {});

  const revenue = story.variablesState.$('revenue_total');
  const costs = story.variablesState.$('cost_total');
  const difficulty = story.variablesState.$('credit_rating') === 'good' ? 'easy' : 'hard';
  const income = revenue - costs;
  const hourlyWage = income / story.variablesState.$('hours_driven_total');

  return fetch(`${endpoint}/decisions`, {
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    method: 'POST',
    body: JSON.stringify({
      revenue,
      meta,
      income,
      hourlyWage,
      difficulty,
      expenses: costs,
    }),
  })
    .then(() => console.info('Endgame data recorded'))
    .catch(e => console.error(`Error recording: ${e}`));
}

function continueStory() {
  const earnings = parseInt(story.variablesState.$('fares_earned_total'), 10);
  const earningsDuringTimePassing = earnings - earningsObj.totalValue;
  const rating = story.variablesState.$('rating');
  const rideCountTotal = story.variablesState.$('ride_count_total');
  const rideCountDuringTimePassing = rideCountTotal - ridesObj.totalValue;
  const time = story.variablesState.$('timestamp') * 1000;
  const timePassing = story.variablesState.$('time_passing');
  const showMoment = story.variablesState.$('moments');
  const timePassingObj = { value: null };
  const timePassingAmountHours = Math.round((time - timeObj.value) / 3600000);
  const showEnding = story.variablesState.$('go_to_endscreen');

  if (story.currentTags.indexOf('sf_or_sacramento') > -1) {
    recordDecision('biz_licence');
  } else if (story.currentTags.indexOf('day_5_start') > -1) {
    recordDecision('helped_homework');
  } else if (story.currentTags.indexOf('day_7_start') > -1) {
    recordDecision('took_day_off');
  }

  // if timestamp between Monday at 12:00 a.m. and Friday at 4:00 a.m.,
  // then number of quests is 75, else 65
  // 1502424000000 is timestamp at 4 a.m. on Friday
  let totalQuests = 75;
  if (time > 1502424000000) {
    totalQuests = 65;
  }
  const questRidesTotal = totalQuests - story.variablesState.$('quest_rides');

  console.log(`rideCountTotal: ${rideCountTotal}, ridesObj: ${ridesObj}`);

  //  record events for analytics
  if (story.currentTags.length > 0 && story.currentTags[0] === 'welcome') {
    gaAnalytics('uber-game', 'start-game');
  }

  function showPanel() {
    const panelIn = anime.timeline();

    // Update background image if appropriate
    const bgImageURL = stateUtils.getBackgroundImageURL();
    let delay = 0;
    if (bgImageURL) {
      delay = 1100;
      gameContainer.setBackgroundImage(bgImageURL);
    }

    panelIn
      .add({
        targets: knotContainer,
        opacity: 1,
        duration: 150,
        easing: 'linear',
        offset: 0,
        delay,
      })
      .add({
        targets: knotContainer,
        translateY: 0,
        duration: 150,
        easing: 'easeOutQuad',
        offset: 0,
        complete: () => {
          const existingChoicesContainer = knotElement.querySelector('.choices-container');
          const existingChoices = Array.from(existingChoicesContainer.querySelectorAll('button'));

          existingChoices.forEach((existingChoice) => {
            const e = existingChoice;

            // console.log(e);

            e.disabled = false;
          });
        },
      });

    // Animate meter readouts
    if (earnings !== earningsObj.totalValue) {
      console.log('Earnings changed, animating meter readout'); // eslint-disable-line no-console
      earningsObj.value = earningsObj.totalValue;

      anime({
        targets: earningsObj,
        value: earnings,
        round: 1,
        duration: () => {
          const milliseconds = (earnings - earningsObj.value) * 20;

          return milliseconds;
        },
        easing: 'linear',
        begin: () => {
          earningsDisplay.style.textShadow = '0 0 6px #ffffff';
        },
        update: () => {
          earningsDisplay.innerHTML = earningsObj.value;
        },
        complete: () => {
          earningsDisplay.style.textShadow = 'none';
          earningsObj.totalValue = earnings;
        },
      });
    }

    if (time !== timeObj.value) {
      console.log('Time changed, animating meter readout'); // eslint-disable-line no-console

      anime({
        targets: timeObj,
        value: time,
        round: 1,
        duration: 500,
        easing: 'linear',
        begin: () => {
          timeDisplay.style.textShadow = '0 0 6px #ffffff';
        },
        update: () => {
          const timeString = moment(timeObj.value)
            .tz('Etc/GMT')
            .format('ddd h:mma');

          timeDisplay.innerHTML = timeString;
        },
        complete: () => {
          timeDisplay.style.textShadow = 'none';
          timeObj.value = time;
        },
      });
    }

    if (rating !== ratingObj.value) {
      console.log('Rating changed, animating meter readout'); // eslint-disable-line no-console

      anime({
        targets: ratingObj,
        value: rating,
        round: 1,
        duration: () => {
          const milliseconds = Math.abs(rating - ratingObj.value) * 20;

          return milliseconds;
        },
        easing: 'linear',
        begin: () => {
          ratingDisplay.style.textShadow = '0 0 6px #ffffff';
        },
        update: () => {
          const r = (ratingObj.value / 100).toFixed(2);

          ratingDisplay.innerHTML = r;
        },
        complete: () => {
          ratingDisplay.style.textShadow = 'none';
          ratingObj.value = rating;
        },
      });
    }
  }

  function closeTimePassing() {
    anime({
      targets: timePassingScreen,
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      begin: () => {
        timePassingScreen.style.webkitBackdropFilter = 'blur(0px)';
      },
      complete: () => {
        timePassingButton.removeEventListener('click', closeTimePassing);
        story.variablesState.$('time_passing', 0);
        timePassingScreen.style.display = 'none';
        showPanel();
      },
    });
  }

  function closeMoment() {
    anime({
      targets: momentScreen,
      opacity: 0,
      duration: defaultInDuration,
      easing: 'linear',
      begin: () => {
        momentScreen.style.webkitBackdropFilter = 'blur(0px)';
      },
      complete: () => {
        momentButton.removeEventListener('click', closeMoment);
        story.variablesState.$('moments', 0);
        momentScreen.style.display = 'none';
        showPanel();
      },
    });
  }

  if (timePassing > 0) {
    const showTimePassingScreen = anime.timeline();

    console.log('Time is passing...'); // eslint-disable-line no-console

    timePassingObj.value = timeObj.value;
    ridesObj.value = 0; // reset ridesObj value to 0 each time
    earningsObj.value = 0;
    timePassingTextHours.innerText =
      timePassingAmountHours > 1
        ? `${timePassingAmountHours} hours`
        : `${timePassingAmountHours} hour`;
    stateUtils
      .loadImage(
        'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959515-koemz.png',
      )
      .then((blob) => {
        timePassingImage.style.backgroundImage = `url(${URL.createObjectURL(blob)})`;
      });
    timePassingDay.innerText = moment(timeObj.value)
      .tz('Etc/GMT')
      .format('E');
    timePassingRideGoalTotal.innerText = totalQuests;
    timePassingButton.addEventListener('click', closeTimePassing);
    timePassingButton.disabled = true;

    // reset questRidesObj if we've switched from weekday to weekend
    // during switch, the current questRidesObj.value will be greater than
    // the value it is changing to
    if (questRidesObj.value > questRidesTotal) {
      questRidesObj.value = 0;
    }

    showTimePassingScreen
      .add({
        targets: timePassingScreen,
        opacity: 1,
        duration: defaultInDuration,
        easing: 'linear',
        begin: () => {
          timePassingScreen.style.display = 'block';
          timePassingScreen.style.webkitBackdropFilter = 'blur(12px)';
        },
        complete: () => {
          timePassingEarnings.style.textShadow = '0 0 12px #ffffff';
          timePassingTime.style.textShadow = '0 0 9px #ffffff';
          timePassingRides.style.textShadow = '0 0 9px #ffffff';
          timePassingRideGoal.style.textShadow = '0 0 9px #ffffff';
        },
      })
      .add({
        targets: earningsObj,
        value: earningsDuringTimePassing,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        update: () => {
          timePassingEarnings.innerHTML = earningsObj.value;
          earningsDisplay.innerHTML = earningsObj.totalValue + earningsObj.value;
        },
        complete: () => {
          timePassingEarnings.style.textShadow = 'none';
          earningsObj.totalValue = earnings;
        },
      })
      .add({
        targets: timePassingObj,
        value: time,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        offset: `-=${timePassingScreenDuration}`,
        update: () => {
          const timeString = moment(timePassingObj.value)
            .tz('Etc/GMT')
            .format('h:mma');
          const timeStringDay = moment(timePassingObj.value)
            .tz('Etc/GMT')
            .format('ddd h:mma');

          timePassingTime.innerHTML = timeString;
          timeDisplay.innerHTML = timeStringDay;
        },
        complete: () => {
          timePassingTime.style.textShadow = 'none';
          timeObj.value = time;
        },
      })
      .add({
        targets: ridesObj,
        value: rideCountDuringTimePassing,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        offset: `-=${timePassingScreenDuration}`,
        update: () => {
          timePassingRides.innerHTML = ridesObj.value;
        },
        complete: () => {
          timePassingRides.style.textShadow = 'none';
          ridesObj.totalValue = rideCountTotal;
        },
      })
      .add({
        targets: questRidesObj,
        value: questRidesTotal,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        offset: `-=${timePassingScreenDuration}`,
        update: () => {
          timePassingRideGoal.innerHTML = questRidesObj.value;
        },
        complete: () => {
          timePassingRideGoal.style.textShadow = 'none';
          questRidesObj.value = questRidesTotal;
          timePassingButton.disabled = false;
        },
      });
  } else if (showMoment > 0) {
    if (story.currentTags[1] === 'first_fare') {
      momentText.innerText = 'You completed your first fare!';
      stateUtils
        .loadImage(
          'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959687-txm6l.png',
          true,
        )
        .then((blob) => {
          momentImage.style.backgroundImage = `url(${URL.createObjectURL(blob)})`;
        });
    } else if (story.currentTags[1] === 'deactivation') {
      momentText.innerText = 'You are temporarily deactivated';
      stateUtils
        .loadImage(
          'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959681-ssvg5.png',
        )
        .then((blob) => {
          momentImage.style.backgroundImage = `url(${URL.createObjectURL(blob)})`;
        });
    } else {
      momentText.innerText = 'Quest completed!';
      stateUtils
        .loadImage(
          'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959674-3xf4r.png',
        )
        .then((blob) => {
          momentImage.style.backgroundImage = `url(${URL.createObjectURL(blob)})`;
        });
    }

    momentTime.innerText = moment(timeObj.value)
      .tz('Etc/GMT')
      .format('h:mma');
    momentDay.innerText = moment(timeObj.value)
      .tz('Etc/GMT')
      .format('E');
    momentRides.innerText = rideCountTotal;
    momentRideGoal.innerText = story.currentTags[1] === 'first_fare' ? '—' : questRidesTotal;
    momentRideGoalTotal.innerText = story.currentTags[1] === 'first_fare' ? '—' : totalQuests;

    momentButton.addEventListener('click', closeMoment);

    anime({
      targets: momentScreen,
      opacity: 1,
      duration: defaultInDuration,
      easing: 'linear',
      begin: () => {
        momentScreen.style.display = 'block';
        momentScreen.style.webkitBackdropFilter = 'blur(12px)';
      },
    });
  } else if (showEnding) {
    endStory();
  } else {
    console.log('>>>'); // eslint-disable-line no-console

    showPanel();
  }

  // Generate story text - loop through available content
  while (story.canContinue) {
    const existingChoicesContainer = knotElement.querySelector('.choices-container');
    // Get ink to generate the next paragraph
    const paragraphText = story.Continue();
    // Create paragraph element
    const paragraphElement = document.createElement('p');

    // if there is a [[[x]]], return string with rounded x (without square brackets)
    paragraphElement.innerHTML = paragraphText.replace(/\[{3}(.+?)\]{3}/g, (match, earningNum) =>
      Math.round(earningNum),
    );

    // Remove existing choices container element
    if (existingChoicesContainer) {
      existingChoicesContainer.parentNode.removeChild(existingChoicesContainer);
    }

    // Create choices container element
    choicesContainerElement = document.createElement('div');
    choicesContainerElement.setAttribute('data-o-grid-colspan', '12 S11 Scenter M7 L6');
    choicesContainerElement.classList.add('choices-container');

    // Conditionally set panel decoration
    if (story.currentTags.indexOf('uber-message') > -1) {
      stateUtils
        .loadImage(
          'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492973346-7mu0u.png',
        )
        .then((blob) => {
          knotDecoration.style.backgroundImage = `url(${URL.createObjectURL(blob)})`;
        });
    } else {
      stateUtils
        .loadImage(
          'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8493380088-0jv5b.png',
        )
        .then((blob) => {
          knotDecoration.style.backgroundImage = `url(${URL.createObjectURL(blob)})`;
        });
    }

    knotElement.appendChild(paragraphElement);
    knotElement.appendChild(choicesContainerElement);
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create button element
    const choiceElement = document.createElement('button');
    choiceElement.classList.add('choice');
    choiceElement.disabled = true;
    choiceElement.innerHTML = `<span>${choice.text}</span>`;

    if (
      story.currentTags.length > 0 &&
      story.currentTags[story.currentTags.length - 1].match(/^to_day_\d+/)
    ) {
      gaAnalytics(
        'uber-game',
        'finish-day',
        parseInt(story.currentTags[story.currentTags.length - 1].split('_')[2], 10) - 1,
      );
    }

    // Make it look different if there's more than one choice available
    if (story.currentTags.indexOf('button') === -1) {
      choiceElement.classList.add('link-like');
    }

    choicesContainerElement.appendChild(choiceElement);

    // Click on choice
    function handleClick(event) {
      event.preventDefault();

      // record choices for analytics
      yourChoices.push(choice.text);

      const panelOut = anime.timeline();

      panelOut
        .add({
          targets: knotContainer,
          opacity: 0,
          duration: 100,
          easing: 'linear',
          offset: 0,
          begin: () => {
            const existingChoices = Array.from(choicesContainerElement.querySelectorAll('button'));

            existingChoices.forEach((existingChoice) => {
              const e = existingChoice;

              e.disabled = true;
            });
          },
        })
        .add({
          targets: knotContainer,
          translateY: 40,
          duration: 100,
          easing: 'easeOutQuad',
          offset: 0,
          complete: () => {
            // Remove all existing paragraphs
            const existingPars = Array.from(knotElement.querySelectorAll('p'));

            existingPars.forEach((existingPar) => {
              const p = existingPar;

              p.parentNode.removeChild(p);
            });

            if (story.currentTags.length > 0) {
              if (story.currentTags[0] === 'choose_difficulty') {
                gaAnalytics('uber-game', 'choose-difficulty', choice.text);
              } else if (story.currentTags[story.currentTags.length - 1].match(/^to_day_\d+/)) {
                gaAnalytics(
                  'uber-game',
                  'start-day',
                  parseInt(story.currentTags[story.currentTags.length - 1].split('_')[2], 10),
                );
              }
            }

            // Tell the story where to go next
            story.ChooseChoiceIndex(choice.index);

            // Aaand loop
            continueStory();
          },
        });
    }

    choiceElement.onclick = handleClick;
  });
}

function startStory() {
  const showStoryScreen = anime.timeline();
  const timeString = moment(timeObj.value)
    .tz('Etc/GMT')
    .format('ddd h:mma');

  showStoryScreen
    .add({
      targets: [shareButtons, caveatsScreen, footer],
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      begin: () => {
        earningsDisplay.innerHTML = earningsObj.totalValue;
        timeDisplay.innerHTML = timeString;
        ratingDisplay.innerHTML = (ratingObj.value / 100).toFixed(2);
        knotContainer.style.transform = 'translateY(40px)';
        knotContainer.style.opacity = 0;
      },
      complete: () => {
        shareButtons.style.display = 'none';
        shareButtons.style.right = '';
        shareButtons.style.left = 0;
        caveatsScreen.style.display = 'none';
        footer.style.display = 'none';
      },
    })
    .add({
      targets: logo,
      left: `${headerWidth}px`,
      duration: defaultInDuration,
      easing: 'easeOutQuad',
      complete: () => {
        logo.style.right = 0;
        logo.style.left = '';
        tint.style.webkitBackdropFilter = 'blur(0px)';
      },
    })
    .add({
      targets: tint,
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      complete: () => {
        tint.style.display = 'none';
        storyScreen.style.display = 'flex';
      },
    })
    .add({
      targets: storyScreen,
      opacity: 1,
      duration: defaultInDuration,
      easing: 'linear',
      complete: () => {
        continueStory();
      },
    });

  gaAnalytics('uber-game', 'start-story');
}

// for analytics when user leaves page
const unloadEventName = 'onbeforeunload' in window ? 'beforeunload' : 'unload';
window.addEventListener(unloadEventName, () => {
  gaAnalytics('uber-game', 'exit-game', JSON.stringify(yourChoices), yourChoices.length);
});

window.addEventListener('load', handleResize);
window.addEventListener('resize', throttle(handleResize, 500));
caveatsButton.addEventListener('click', showCaveats);
startButton.addEventListener('click', startStory);
stateUtils.loadImage(
  'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959515-koemz.png',
  true,
); // Time passing
stateUtils.loadImage(
  'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959687-txm6l.png',
  true,
); // First fare
stateUtils.loadImage(
  'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959681-ssvg5.png',
  true,
); // Deactivation
stateUtils.loadImage(
  'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492959674-3xf4r.png',
  true,
); // Quest completed
stateUtils.loadImage(
  'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8493380088-0jv5b.png',
  true,
); // Default panel decoration
stateUtils.loadImage(
  'http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8492973346-7mu0u.png',
  true,
); // Uber message panel decoration

// visiting `localhost:8080/?end` skips to the end
{
  const { searchParams } = new URL(location.href);

  if (searchParams.has('end')) {
    story.variablesState.$('hours_driven_total', 1814);
    story.variablesState.$('fares_earned_total', 1345);
    story.variablesState.$('ride_count_total', 143);
    story.variablesState.$('rating', 476);
    story.variablesState.$('weekday_quest_completion', true);
    story.variablesState.$('weekday_quest_bonus', 180);
    story.variablesState.$('weekend_quest_completion', true);
    story.variablesState.$('weekend_quest_bonus', 150);
    story.variablesState.$('car_cost', 180);
    story.variablesState.$('gas_cost', 231);
    story.variablesState.$('accessories_cost', 90);
    story.variablesState.$('repair_cost', 140);
    story.variablesState.$('took_day_off', true);

    continueStory();
    endStory();
  }
}

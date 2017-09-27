import anime from 'animejs';
import { Story } from 'inkjs';
import Modernizr from './modernizr';
import twemoji from 'twemoji';
import json from './uber.json';
import './styles.scss';

const story = new Story(json);
// Elements
const logo = document.querySelector('.logo');
const shareButtons = document.querySelector('.article__share');
const footer = document.querySelector('.o-typography-footer');
const tint = document.querySelector('.tint');
const introScreen = document.getElementById('intro');
const caveatsButton = document.getElementById('caveats-button');
const caveatsScreen = document.getElementById('caveats');
const startButton = document.getElementById('start-button');
const storyScreen = document.getElementById('story');
const earningsDisplay = document.getElementById('earnings');
const timeDisplay = document.getElementById('time');
const ratingDisplay = document.getElementById('rating');
const knotContainer = document.querySelector('.knot-container');
const knotElement = document.querySelector('.knot');
const timePassingScreen = document.querySelector('.time-passing-container');
const timePassingTextHours = document.getElementById('time-passing-text__hours');
const timePassingEarnings = document.getElementById('tp-earnings');
const timePassingTime = document.getElementById('tp-time');
const timePassingRides = document.getElementById('tp-rides');
const timePassingRideGoal = document.getElementById('tp-ride-goal');
const timePassingRideGoalTotal = document.getElementById('tp-ride-goal-total');
const momentScreen = document.querySelector('.moment-container');
const momentText = document.getElementById('moment-text')
const momentImage = document.querySelector('.moment-image')
const momentButton = document.getElementById('moment-button');
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
const timePassingScreenDuration = 3000;
const earningsObj = { value: 0 };
const timeObj = { value: 1502092800000 };
const ratingObj = { value: 500 };
// ridesObj.value counts for ride count during time passing screens
// ridesObj.totalValue counts total number of rides during game
const ridesObj = { value: 0, totalValue: 0 };
const questRidesObj = { value: 0 };

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

  console.log(`Window resized ${d.toLocaleTimeString()}`);
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
}

function continueStory() {
  const earnings = parseInt(story.variablesState.$('fares_earned_total'), 10);
  const questRidesTotal = 75 - story.variablesState.$('quest_rides'); // @TODO: Get 75 from variable
  const rating = story.variablesState.$('rating');
  const rideCountTotal = story.variablesState.$('ride_count_total');
  const rideCountDuringTimePassing = rideCountTotal - ridesObj.totalValue;
  const time = story.variablesState.$('timestamp') * 1000;
  const timePassing = story.variablesState.$('time_passing');
  const moment = story.variablesState.$('moments');
  const timePassingObj = { value: null };

  console.log(timePassing, moment);

  function showPanel() {
    anime({
      targets: knotContainer,
      translateY: 0,
      opacity: 1,
      duration: 150,
      easing: 'easeOutQuad',
    });

    // Animate meter readouts
    if (earnings !== earningsObj.value) {
      console.log('Earnings changed, animating meter readout');

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
          earningsDisplay.style.textShadow = '0 0 6px white';
        },
        update: () => {
          earningsDisplay.innerHTML = earningsObj.value;
        },
        complete: () => {
          earningsDisplay.style.textShadow = 'none';
          earningsObj.value = earnings;
        },
      });
    }

    if (time !== timeObj.value) {
      console.log('Time changed, animating meter readout');

      anime({
        targets: timeObj,
        value: time,
        round: 1,
        duration: 500,
        easing: 'linear',
        begin: () => {
          timeDisplay.style.textShadow = '0 0 6px white';
        },
        update: () => {
          const timeString = new Date(parseInt(timeObj.value, 10)).toLocaleTimeString('en-us', { timeZone: 'GMT', hour12: true });

          console.log(timeString);

          if (timeString.length < 11) {
            timeDisplay.innerHTML = `${timeString.slice(0, 4)}${timeString.slice(-2)}`;
          } else {
            timeDisplay.innerHTML = `${timeString.slice(0, 5)}${timeString.slice(-2)}`;
          }
        },
        complete: () => {
          timeDisplay.style.textShadow = 'none';
          timeObj.value = time;
        },
      });
    }

    if (rating !== ratingObj.value) {
      console.log('Rating changed, animating meter readout');

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
          ratingDisplay.style.textShadow = '0 0 6px white';
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

  function hideMoment() {
    anime({
      targets: momentScreen,
      opacity: 0,
      duration: defaultInDuration,
      easing: 'linear',
      begin: () => {
        momentScreen.style.webkitBackdropFilter = 'blur(0px)';
        momentScreen.style.backdropFilter = 'blur(0px)';
      },
      complete: () => {
        momentScreen.style.display = 'none';
        showPanel();
        momentButton.removeEventListener('click', hideMoment);
      },
    });
  }

  if (timePassing > 0) {
    const showTimePassingScreen = anime.timeline();

    console.log('Time is passing...');

    const timePassingAmountHours = Math.round((time - timeObj.value) / 3600000);
    timePassingObj.value = timeObj.value;
    ridesObj.value = 0; // reset ridesObj value to 0 each time
    timePassingTextHours.innerText = timePassingAmountHours;
    timePassingRideGoalTotal.innerText = 75; // @TODO: Add logic for either 65 or 75

    showTimePassingScreen
      .add({
        targets: timePassingScreen,
        opacity: 1,
        duration: defaultInDuration,
        easing: 'linear',
        begin: () => {
          timePassingScreen.style.display = 'block';
          timePassingScreen.style.webkitBackdropFilter = 'blur(8px)';
          timePassingScreen.style.backdropFilter = 'blur(8px)';
        },
      })
      .add({
        targets: earningsObj,
        value: earnings,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        offset: 0,
        update: () => {
          earningsDisplay.innerHTML = earningsObj.value;
          timePassingEarnings.innerHTML = earningsObj.value;
        },
        complete: () => {
          earningsObj.value = earnings;
        },
      })
      .add({
        targets: timePassingObj,
        value: time,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        offset: 0,
        update: () => {
          const timeString = new Date(parseInt(timePassingObj.value, 10)).toLocaleTimeString('en-us', { timeZone: 'GMT', hour12: true });

          if (timeString.length < 11) {
            timePassingTime.innerHTML = `${timeString.slice(0, 4)}${timeString.slice(-2)}`;
            timeDisplay.innerHTML = `${timeString.slice(0, 4)}${timeString.slice(-2)}`;
          } else {
            timePassingTime.innerHTML = `${timeString.slice(0, 5)}${timeString.slice(-2)}`;
            timeDisplay.innerHTML = `${timeString.slice(0, 5)}${timeString.slice(-2)}`;
          }
        },
        complete: () => {
          story.variablesState.$('time_passing', 0);
          timeObj.value = time;
        },
      })
      .add({
        targets: ridesObj,
        value: rideCountDuringTimePassing,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        offset: 0,
        update: () => {
          timePassingRides.innerHTML = ridesObj.value;
        },
        complete: () => {
          ridesObj.totalValue = rideCountTotal;
        },
      })
      .add({
        targets: questRidesObj,
        value: questRidesTotal,
        round: 1,
        duration: timePassingScreenDuration,
        easing: 'linear',
        offset: 0,
        update: () => {
          timePassingRideGoal.innerHTML = questRidesObj.value;
        },
        complete: () => {
          questRidesObj.value = questRidesTotal;
        },
      })
      .add({
        targets: timePassingScreen,
        opacity: 0,
        duration: defaultOutDuration,
        easing: 'linear',
        begin: () => {
          timePassingScreen.style.webkitBackdropFilter = 'blur(0px)';
          timePassingScreen.style.backdropFilter = 'blur(0px)';
        },
        complete: () => {
          timePassingScreen.style.display = 'none';

          showPanel();
        },
      });
  } else if (moment > 0) {
    console.log(`A moment just happened. It was ${story.currentTags[1]}`);

    if (story.currentTags[1] === 'first_fare') {
      momentText.innerText = 'You completed your first fare!';
      momentImage.style.backgroundImage = 'url(http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8493569815-ed2um.png)';
    } else if (story.currentTags[1] === 'deactivation') {
      momentText.innerText = 'You are temporarily deactivated';
      momentImage.style.backgroundImage = 'url(http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8493569802-n5e5e.png)';
    } else {
      momentText.innerText = 'Quest completed!';
      momentImage.style.backgroundImage = 'url(http://ft-ig-images-prod.s3-website-eu-west-1.amazonaws.com/v1/8493569784-1opf4.png)';
    }

    momentButton.addEventListener('click', hideMoment);

    anime({
      targets: momentScreen,
      opacity: 1,
      duration: defaultInDuration,
      easing: 'linear',
      begin: () => {
        momentScreen.style.display = 'block';
        momentScreen.style.webkitBackdropFilter = 'blur(8px)';
        momentScreen.style.backdropFilter = 'blur(8px)';
      },
      complete: () => {
        story.variablesState.$('moments', 0);
      },
    });
  } else {
    console.log('>>>');

    showPanel();
  }

  // Generate story text - loop through available content
  while (story.canContinue) {
    const existingChoicesContainer = knotElement.querySelector('.choices-container');
    // Get ink to generate the next paragraph
    const paragraphText = story.Continue();
    // Create paragraph element
    const paragraphElement = document.createElement('p');

    console.log(story.currentTags);

    paragraphElement.innerHTML = paragraphText;

    // Remove existing choices container element
    if (existingChoicesContainer) {
      existingChoicesContainer.parentNode.removeChild(existingChoicesContainer);
    }

    // Create choices container element
    choicesContainerElement = document.createElement('div');
    choicesContainerElement.setAttribute('data-o-grid-colspan', '12 S11 Scenter M7 L6 XL5');
    choicesContainerElement.classList.add('choices-container');

    knotElement.appendChild(paragraphElement);
    knotElement.appendChild(choicesContainerElement);
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create button element
    const choiceElement = document.createElement('button');
    let choiceString = twemoji.parse(choice.text, {
      callback: (iconId, options) => `/assets/${options.size}/${iconId}.gif`,
      size: 18,
    });
    choiceElement.classList.add('choice');
    choiceElement.innerHTML = `<span>${choiceString}</span>`;

    // Make it look different if there's more than one choice available
    if (story.currentTags.indexOf('button') === -1) {
      choiceString = twemoji.parse(choice.text, {
        callback: (iconId, options) => `/assets/${options.size}/${iconId}.gif`,
        size: 18,
      });
      choiceElement.classList.add('link-like');
      choiceElement.innerHTML = `<span>${choiceString}</span>`;
    }

    choicesContainerElement.appendChild(choiceElement);

    // Click on choice
    function handleClick(event) {
      event.preventDefault();

      if (choiceElement.classList.contains('link-like')) {
        choiceElement.style.color = '#333';
      }

      // Remove unclicked choices
      const prevChoices = Array.from(storyScreen.querySelectorAll('.choice'));
      const clickedChoiceIndex = prevChoices.findIndex(el => el.innerText === choice.text);

      prevChoices.forEach((prevChoice, i) => {
        const el = prevChoice;

        if (i !== clickedChoiceIndex) {
          el.style.opacity = 0;
        }
      });

      anime({
        targets: knotContainer,
        translateY: 40,
        opacity: 0,
        duration: 100,
        easing: 'easeOutQuad',
        complete: () => {
          // Remove all existing paragraphs
          const existingPars = Array.from(knotElement.querySelectorAll('p'));

          existingPars.forEach((existingPar) => {
            const p = existingPar;

            p.parentNode.removeChild(p);
          });

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
  const timeString = new Date(parseInt(timeObj.value, 10)).toLocaleTimeString('en-us', { timeZone: 'GMT', hour12: true });

  showStoryScreen
    .add({
      targets: [shareButtons, caveatsScreen, footer],
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      offset: 0,
      begin: () => {
        earningsDisplay.innerHTML = earningsObj.value;
        timeDisplay.innerHTML = `${timeString.slice(0, 4)}${timeString.slice(-2)}`;
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
        tint.style.webkitBackdropFilter = 'blur(0px)';
      },
    })
    .add({
      targets: logo,
      left: `${headerWidth}px`,
      duration: defaultInDuration,
      easing: 'easeOutQuad',
      complete: () => {
        storyScreen.style.display = 'flex';
        logo.style.right = 0;
        logo.style.left = '';
      },
    })
    .add({
      targets: tint,
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      complete: () => {
        tint.style.display = 'none';
      },
    })
    .add({
      targets: storyScreen,
      opacity: 1,
      duration: defaultInDuration,
      easing: 'linear',
      offset: `-=${defaultOutDuration}`,
      complete: () => {
        continueStory();
      },
    });
}

window.addEventListener('load', handleResize);
window.addEventListener('resize', handleResize);
caveatsButton.addEventListener('click', showCaveats);
startButton.addEventListener('click', startStory);

import anime from 'animejs';
import { Story } from 'inkjs';
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
const timePassingScreen = document.querySelector('.time-passing');
const timePassingDisplay = document.getElementById('countdown');
// const timePassingEarnings = document.getElementById('tp-earnings');
// const timePassingTime = document.getElementById('tp-time');
// const timePassingRating = document.getElementById('tp-rating');
let choicesContainerElement;
// Dimensions
let gutterWidth;
let headerWidth;
const logoHeight = logo.offsetHeight;
let articleBodyHeight;
let knotContainerMaxHeight;
// Needed for animations
const defaultInDuration = 500;
const defaultOutDuration = 300;
const earningsObj = { value: 0 };
const timeObj = { value: 1502092800000 };
const ratingObj = { value: 500 };

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

window.addEventListener('load', handleResize);

window.addEventListener('resize', handleResize);

function showCaveats() {
  anime({
    targets: introScreen,
    opacity: 0,
    duration: defaultOutDuration,
    easing: 'linear',
    complete: () => {
      introScreen.style.display = 'none';
      caveatsScreen.style.display = 'block';

      anime({
        targets: caveatsScreen,
        opacity: 1,
        duration: defaultInDuration,
        easing: 'linear',
      });
    },
  });
}

caveatsButton.addEventListener('click', showCaveats);

function continueStory() {
  const earnings = parseInt(story.variablesState.$('fares_earned_total'), 10);
  const rating = story.variablesState.$('rating');
  const time = story.variablesState.$('timestamp') * 1000;
  const timePassing = story.variablesState.$('time_passing');
  const timePassingObj = { value: 3 };

  console.log(timeObj.value, new Date(parseInt(timeObj.value, 10)).toLocaleTimeString('en-us', { timeZone: 'GMT', hour12: true }), 'continueStory');

  function showPanel() {
    anime({
      targets: knotContainer,
      bottom: 0,
      duration: defaultInDuration,
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

  if (timePassing > 0) {
    const showTimePassingScreen = anime.timeline();

    console.log('Time is passing...');

    showTimePassingScreen
      .add({
        targets: timePassingScreen,
        opacity: 1,
        duration: 300,
        easing: 'linear',
        begin: () => {
          timePassingScreen.style.display = 'flex';
          timePassingScreen.style.webkitBackdropFilter = 'blur(8px)';
          timePassingScreen.style.backdropFilter = 'blur(8px)';
        },
      })
      .add({
        targets: timePassingObj,
        value: 1,
        round: 1,
        duration: 3000,
        easing: 'linear',
        update: () => {
          timePassingDisplay.innerHTML = timePassingObj.value;
        },
        complete: () => {
          story.variablesState.$('time_passing', 0);
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
      size: 16,
    });
    choiceElement.classList.add('choice');
    choiceElement.innerHTML = `<span>${choiceString}</span>`;

    if (story.currentTags.indexOf('button') === -1) {
      choiceString = twemoji.parse(choice.text, {
        callback: (iconId, options) => `/assets/${options.size}/${iconId}.gif`,
        size: 18,
      });
      choiceElement.classList.add('link-like');
      choiceElement.innerHTML = `<span>${choiceString}</span>`;
      // choiceElement.innerHTML = `<i class="icon-arrow-right"></i>${choice.text}`;
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
        bottom: `-${articleBodyHeight}px`,
        duration: defaultOutDuration,
        delay: defaultOutDuration,
        easing: 'easeOutQuad',
        complete: () => {
          // Remove all existing paragraphs
          const existingPars = knotElement.querySelectorAll('p');

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

  console.log(timeObj.value, timeString, 'startStory');

  tint.style.webkitBackdropFilter = 'blur(0px)';
  tint.style.backdropFilter = 'blur(0px)';

  showStoryScreen
    .add({
      targets: [shareButtons, caveatsScreen, footer, tint],
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      begin: () => {
        earningsDisplay.innerHTML = earningsObj.value;
        timeDisplay.innerHTML = `${timeString.slice(0, 4)}${timeString.slice(-2)}`;
        ratingDisplay.innerHTML = (ratingObj.value / 100).toFixed(2);
        knotContainer.style.bottom = `-${articleBodyHeight}px`;
      },
      complete: () => {
        shareButtons.style.display = 'none';
        shareButtons.style.right = '';
        shareButtons.style.left = 0;
        caveatsScreen.style.display = 'none';
        footer.style.display = 'none';
        tint.style.display = 'none';
      },
    })
    .add({
      targets: logo,
      left: `${headerWidth}px`,
      duration: defaultInDuration,
      easing: 'easeOutQuad',
      complete: () => {
        storyScreen.style.display = 'block';
        logo.style.right = 0;
        logo.style.left = '';
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

startButton.addEventListener('click', startStory);

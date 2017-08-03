import { Story } from 'inkjs';
import anime from 'animejs';
import json from './uber.json';

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
let choicesContainerElement;

// Dimensions
let headerWidth;
let gutterWidth;
const logoHeight = logo.offsetHeight;
let articleBodyHeight;
let knotContainerMaxHeight;

// Needed for animations
const defaultInDuration = 300;
const defaultOutDuration = 500;
const earningsObj = { value: 0 };
const timeObj = { value: 0 };
const ratingObj = { value: 490 };

function handleResize() {
  const d = new Date();

  headerWidth = document.querySelector('header').offsetWidth - 40;
  gutterWidth = window.innerWidth < 740 ? 10 : 20;
  articleBodyHeight = document.querySelector('.article-body').offsetHeight;
  knotContainerMaxHeight = articleBodyHeight - logoHeight - 16;

  knotContainer.style.maxHeight = `${knotContainerMaxHeight}px`;

  if (!logo.style.right) {
    logo.style.left = `${gutterWidth}px`;
  }

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
  // const time = 0;

  // Animate meter readouts
  if (earnings !== earningsObj.value) {
    console.log('Earnings changed, animating meter readout...');

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

  // if (time !== timeObj.value) {
  //   console.log('Time changed, animating meter readout...');
  //
  //   anime({
  //     targets: timeObj,
  //     value: time,
  //     round: 1,
  //     duration: () => {
  //       const milliseconds = (time - timeObj.value) * 20;
  //
  //       return milliseconds;
  //     },
  //     easing: 'linear',
  //     update: () => {
  //       timeDisplay.innerHTML = timeObj.value;
  //     },
  //     complete: () => {
  //       timeObj.value = time;
  //     },
  //   });
  // }

  if (rating !== ratingObj.value) {
    console.log('Rating changed, animating meter readout...');

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
    choicesContainerElement.setAttribute('data-o-grid-colspan', '9 center S8 M7 L6 XL5');
    choicesContainerElement.classList.add('choices-container');

    knotElement.appendChild(paragraphElement);
    knotElement.appendChild(choicesContainerElement);
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    let choiceElement;

    if (story.currentTags.indexOf('button') > -1) {
      // Create paragraph with button element
      choiceElement = document.createElement('button');
      choiceElement.classList.add('choice');
      choiceElement.innerHTML = choice.text;
    } else {
      // Create paragraph with anchor element(s)
      choiceElement = document.createElement('p');
      choiceElement.classList.add('choice');
      choiceElement.innerHTML = `<a href='#'>${choice.text}</a>`;
    }

    choicesContainerElement.appendChild(choiceElement);

    anime({
      targets: knotContainer,
      bottom: 0,
      duration: defaultInDuration,
      easing: 'easeOutQuad',
    });

    // Click on choice
    function handleClick(event) {
      // Don't follow <a> link
      event.preventDefault();

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
        delay: defaultOutDuration / 2,
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
  const showMeters = anime.timeline();

  showMeters
    .add({
      targets: [shareButtons, caveatsScreen, footer],
      opacity: 0,
      duration: defaultOutDuration,
      easing: 'linear',
      begin: () => {
        earningsDisplay.innerHTML = earningsObj.value;
        timeDisplay.innerHTML = timeObj.value;
        ratingDisplay.innerHTML = (ratingObj.value / 100).toFixed(2);
        knotContainer.style.bottom = `-${articleBodyHeight}px`;
        tint.style.opacity = 0;
        tint.style.backdropFilter = 'none';
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
      targets: [logo, storyScreen],
      left: (el) => {
        let left = '';

        if (el.getAttribute('data-anime-left') === 'true') {
          left = `${headerWidth}px`;
        }

        return left;
      },
      opacity: (el) => {
        let opacity = '';

        if (el.getAttribute('data-anime-opacity') === 'true') {
          opacity = 1;
        }

        return opacity;
      },
      duration: defaultInDuration,
      easing: (el) => {
        if (el.getAttribute('data-anime-left') === 'true') {
          return 'easeOutQuad';
        }

        return 'linear';
      },
      begin: () => {
        storyScreen.style.display = 'block';
        continueStory();
      },
      complete: () => {
        logo.style.right = 0;
        logo.style.left = '';
      },
    });
}

startButton.addEventListener('click', startStory);

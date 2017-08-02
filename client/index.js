import { Story } from 'inkjs';
import anime from 'animejs';
import json from './uber.json';

const story = new Story(json);
let headerWidth;
let gutters;
const logo = document.querySelector('.logo');
const logoHeight = logo.offsetHeight;
const shareButtons = document.querySelector('.article__share');
let articleBodyHeight;
const footer = document.querySelector('.o-typography-footer');
const introScreen = document.getElementById('intro');
const caveatsButton = document.getElementById('caveats-button');
const caveatsScreen = document.getElementById('caveats');
const startButton = document.getElementById('start-button');
const storyScreen = document.getElementById('story');
const knotContainer = document.querySelector('.knot-container');
let knotContainerMaxHeight;
const knotElement = document.querySelector('.knot');
const tint = document.querySelector('.tint');
const defaultInDuration = 600;
const defaultOutDuration = 600;

function handleResize() {
  const d = new Date();

  articleBodyHeight = document.querySelector('.article-body').offsetHeight;
  knotContainerMaxHeight = articleBodyHeight - logoHeight - 16;
  knotContainer.style.maxHeight = `${knotContainerMaxHeight}px`;
  gutters = window.innerWidth < 740 ? 10 : 20;
  headerWidth = document.querySelector('header').offsetWidth - 40;

  if (!logo.style.right) {
    logo.style.left = `${gutters}px`;
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
  let choicesContainerElement;
  const earnings = story.variablesState.$('fares_earned_total');
  const earningsDisplay = document.getElementById('earnings');
  const rating = parseFloat(story.variablesState.$('rating').toFixed(2));
  const ratingDisplay = document.getElementById('rating');
  const time = story.variablesState.$('rating');
  const timeDisplay = document.getElementById('time');

  // Coerce rating variable to 2 decimal places
  story.variablesState.$('rating', rating);
  console.log(story.variablesState.$('rating'));

  earningsDisplay.innerHTML = earnings;
  ratingDisplay.innerHTML = rating;

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

    // console.log(story.currentTags);

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

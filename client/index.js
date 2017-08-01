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

function continueStory() {
  let choicesContainerElement;
  const totalDisplay = document.getElementById('total');
  const total = story.variablesState.$('fares_earned_total');

  totalDisplay.innerHTML = total;

  // Generate story text - loop through available content
  while (story.canContinue) {
    // Get ink to generate the next paragraph
    const paragraphText = story.Continue();

    // Create paragraph element
    const paragraphElement = document.createElement('p');
    paragraphElement.innerHTML = paragraphText;

    // Create choices container element
    choicesContainerElement = document.createElement('div');
    choicesContainerElement.setAttribute('data-o-grid-colspan', '8 center');
    choicesContainerElement.classList.add('choices-container');

    knotElement.appendChild(paragraphElement);
    knotElement.appendChild(choicesContainerElement);
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    console.log(story.currentTags);

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

    // const choiceAnchorEl = choiceElement.querySelector('a');

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
          // Remove all remaining child elements
          while (knotElement.firstChild) {
            knotElement.removeChild(knotElement.firstChild);
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
  const showMeters = anime.timeline();
  // const

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
      targets: logo,
      left: `${headerWidth}px`,
      duration: defaultInDuration,
      easing: 'easeOutQuad',
      complete: () => {
        logo.style.right = 0;
        logo.style.left = '';
      },
    })
    .add({
      targets: storyScreen,
      opacity: 1,
      duration: defaultInDuration,
      easing: 'linear',
      begin: () => { storyScreen.style.display = 'block'; },
      complete: continueStory,
    });
}

caveatsButton.addEventListener('click', showCaveats);

startButton.addEventListener('click', startStory);

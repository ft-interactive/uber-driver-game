import { Story } from 'inkjs';
import anime from 'animejs';
import fscreen from 'fscreen';
import json from './uber.json';

const story = new Story(json);
const shareButtons = document.querySelector('.article__share');
let articleBodyHeight;
const footer = document.querySelector('.o-typography-footer');
const introScreen = document.getElementById('intro');
const caveatsButton = document.getElementById('caveats-button');
const caveatsScreen = document.getElementById('caveats');
const enterFullscreenButton = document.getElementById('enter-fullscreen-button');
const exitFullscreenButton = document.getElementById('exit-fullscreen-button');
const startButton = document.getElementById('start-button');
const storyScreen = document.getElementById('story');
let metersElementHeight;
const knotContainer = document.querySelector('.knot-container');
let knotContainerMaxHeight;
const knotElement = document.querySelector('.knot');
const tint = document.querySelector('.tint');
const defaultInDuration = 600;
const defaultOutDuration = 600;

function handleResize() {
  const articleBody = document.querySelector('.article-body');
  const metersElement = document.querySelector('.meters');
  const d = new Date();

  articleBodyHeight = articleBody.offsetHeight;
  metersElementHeight = metersElement.offsetHeight;
  knotContainerMaxHeight = articleBodyHeight - metersElementHeight;
  knotContainer.style.maxHeight = `${knotContainerMaxHeight}px`;

  console.log(`Window resized ${d.toLocaleTimeString()}`);

  console.log(window.outerWidth);
}

window.addEventListener('load', handleResize);

window.addEventListener('resize', handleResize);

function handleFullscreen() {
  if (fscreen.fullscreenElement !== null) {
    console.log('Entered fullscreen mode');
  } else {
    console.log('Exited fullscreen mode');
  }
}

function showCaveats() {
  if (fscreen.fullscreenEnabled && window.outerWidth < 1024) {
    const fullscreenButtonsElement = document.querySelector('.toggle-fullscreen');

    fscreen.addEventListener('fullscreenchange', handleFullscreen, false);

    enterFullscreenButton.addEventListener('click', () => fscreen.requestFullscreen(document.querySelector('main')));

    exitFullscreenButton.addEventListener('click', () => fscreen.exitFullscreen());

    fullscreenButtonsElement.style.display = 'block';
  }

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
  const totalDisplay = document.getElementById('total');
  const total = story.variablesState.$('fares_earned_total');

  totalDisplay.innerHTML = total;


  // Generate story text - loop through available content
  while (story.canContinue) {
    // Get ink to generate the next paragraph
    const paragraphText = story.Continue();

    // console.log(story.currentTags);

    // Create paragraph element
    const paragraphElement = document.createElement('p');

    paragraphElement.innerHTML = paragraphText;

    knotElement.appendChild(paragraphElement);

    // if (story.currentTags.indexOf('type: choice') > -1) {
    //   knotElement.style.color = 'red';
    // } else {
    //   knotElement.style.color = '#fff';
    // }
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create paragraph with anchor element
    const choiceElement = document.createElement('p');

    choiceElement.classList.add('choice');
    choiceElement.innerHTML = `<a href='#'>${choice.text}</a>`;

    knotElement.appendChild(choiceElement);

    anime({
      targets: knotContainer,
      bottom: '18px',
      duration: defaultInDuration,
      easing: 'easeOutQuad',
    });

    const choiceAnchorEl = choiceElement.querySelector('a');

    // Click on choice
    function handleClick(event) {
      // Don't follow <a> link
      event.preventDefault();

      // Remove unclicked choices
      const prevChoices = Array.from(storyScreen.querySelectorAll('p.choice'));
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

    choiceAnchorEl.onclick = handleClick;
  });
}

function startStory() {
  tint.style.opacity = 0;
  tint.style.backdropFilter = 'none';

  anime({
    targets: [shareButtons, caveatsScreen, footer],
    opacity: 0,
    duration: defaultOutDuration,
    easing: 'linear',
    begin: () => { knotContainer.style.bottom = `-${articleBodyHeight}px`; },
    complete: () => {
      shareButtons.style.display = 'none';
      caveatsScreen.style.display = 'none';
      footer.style.display = 'none';

      anime({
        targets: storyScreen,
        opacity: 1,
        duration: defaultInDuration,
        easing: 'linear',
        begin: () => { storyScreen.style.display = 'block'; },
        complete: continueStory,
      });
    },
  });
}

caveatsButton.addEventListener('click', showCaveats);

startButton.addEventListener('click', startStory);

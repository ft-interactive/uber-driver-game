import { Story } from 'inkjs';
import anime from 'animejs';
import json from './uber.json';

const story = new Story(json);
const shareButtons = document.querySelector('.article__share');
let articleBodyHeight;
const footer = document.querySelector('.o-typography-footer');
const introScreen = document.getElementById('intro');
const caveatsButton = document.getElementById('caveats-button');
const caveatsScreen = document.getElementById('caveats');
const startButton = document.getElementById('start-button');
const storyScreen = document.getElementById('story');
let metersElementHeight;
const knotElement = document.querySelector('.knot');
let knotElementMaxHeight;
const tint = document.querySelector('.tint');
const defaultInDuration = 600;
const defaultOutDuration = 600;

function handleResize() {
  const d = new Date();

  articleBodyHeight = document.querySelector('.article-body').offsetHeight;
  metersElementHeight = document.querySelector('.meters').offsetHeight;
  knotElementMaxHeight = articleBodyHeight - metersElementHeight;
  knotElement.style.maxHeight = `${knotElementMaxHeight}px`;

  console.log(`Window resized ${d.toLocaleTimeString()}`);
}

window.addEventListener('load', handleResize);

window.addEventListener('resize', handleResize);

function showCaveats() {
  console.log('fired');

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
    // Create paragraph element
    const paragraphElement = document.createElement('p');

    paragraphElement.innerHTML = paragraphText;

    knotElement.appendChild(paragraphElement);
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create paragraph with anchor element
    const choiceElement = document.createElement('p');

    choiceElement.classList.add('choice');
    choiceElement.innerHTML = `<a href='#'>${choice.text}</a>`;

    knotElement.appendChild(choiceElement);

    anime({
      targets: knotElement,
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
        targets: knotElement,
        bottom: `-${articleBodyHeight}px`,
        duration: defaultOutDuration,
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
    complete: () => {
      shareButtons.style.display = 'none';
      caveatsScreen.style.display = 'none';
      footer.style.display = 'none';
      storyScreen.style.display = 'block';
      articleBodyHeight = document.querySelector('.article-body').offsetHeight;
      metersElementHeight = document.querySelector('.meters').offsetHeight;
      knotElementMaxHeight = articleBodyHeight - metersElementHeight;
      knotElement.style.maxHeight = `${knotElementMaxHeight}px`;

      anime({
        targets: storyScreen,
        opacity: 1,
        duration: defaultInDuration,
        easing: 'linear',
        complete: continueStory,
      });
    },
  });
}

caveatsButton.addEventListener('click', showCaveats);

startButton.addEventListener('click', startStory);

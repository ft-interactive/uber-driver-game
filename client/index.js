import { Story } from 'inkjs';
import anime from 'animejs';
import json from './uber.json';

const story = new Story(json);
const viewportHeight = window.innerHeight;
const tint = document.querySelector('.tint');
const articleBodyHeight = document.querySelector('.article-body').offsetHeight;
const introScreen = document.getElementById('intro');
const shareButtons = document.querySelector('.article__share');
const footer = document.querySelector('.o-typography-footer');
const storyScreen = document.getElementById('story');
const defaultInDuration = 1000;
const defaultOutDuration = 1500;
const startButton = document.getElementById('start-button');

function continueStory() {
  const knotElement = document.querySelector('.knot');
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

    const knotHeight = knotElement.offsetHeight;
    const knotTranslateY = articleBodyHeight - knotHeight;

    anime({
      targets: knotElement,
      translateY: knotTranslateY,
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
        translateY: articleBodyHeight,
        duration: 3000,
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

    choiceAnchorEl.onclick = handleClick;
  });
}


function startStory() {
  tint.style.opacity = 0;
  tint.style.backdropFilter = 'none';

  anime({
    targets: [introScreen, shareButtons, footer],
    opacity: 0,
    duration: defaultOutDuration,
    easing: 'linear',
    update: (anim) => {
      if (anim.completed) {
        storyScreen.style.display = 'block';

        anime({
          targets: storyScreen,
          opacity: 1,
          duration: defaultInDuration,
          easing: 'linear',
        });

        introScreen.style.display = 'none';
        shareButtons.style.display = 'none';
        footer.style.display = 'none';

        continueStory();
      }
    },
  });
}

startButton.onclick = startStory;

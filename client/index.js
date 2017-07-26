import { Story } from 'inkjs';
import anime from 'animejs';
import json from './uber.json';

const story = new Story(json);
const tint = document.querySelector('.tint');
const introScreen = document.getElementById('intro');
const storyContainer = document.getElementById('story');
const startButton = document.getElementById('start-button');
const shareButtons = document.querySelector('.article__share');
const footer = document.querySelector('.o-typography-footer');
const inDuration = 1000;
const outDuration = 2000;

function startStory() {
  tint.classList.remove('pre-game');
  tint.classList.add('in-game');

  const fadeOutIntro = anime({
    targets: [introScreen, shareButtons, footer],
    opacity: 0,
    duration: inDuration,
    easing: 'linear',
  });

  const fadeInGame = anime({
    targets: storyContainer,
    opacity: 1,
    duration: outDuration,
    easing: 'linear',
  });

  fadeOutIntro.update = (anim) => {
    if (anim.completed) {
      introScreen.style.display = 'none';

      storyContainer.style.display = 'block';

      fadeInGame.play();
    }
  };
}

startButton.onclick = startStory;

function continueStory() {
  // const paragraphIndex = 0;
  const storyScreen = document.createElement('div');
  const totalDisplay = document.getElementById('total');
  const total = story.variablesState.$('fares_earned_total');

  storyScreen.classList.add('screen');
  // storyScreen.classList.add('game');

  totalDisplay.innerHTML = total;

  // Generate story text - loop through available content
  while (story.canContinue) {
    // Get ink to generate the next paragraph
    const paragraphText = story.Continue();
    // Create paragraph element
    const paragraphElement = document.createElement('p');

    paragraphElement.innerHTML = paragraphText;

    storyContainer.appendChild(storyScreen);

    storyScreen.appendChild(paragraphElement);

    // Fade in paragraph after a short delay
    anime({
      targets: paragraphElement,
      opacity: 1,
      duration: inDuration,
      delay: 300,
    });
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create paragraph with anchor element
    const choiceParagraphElement = document.createElement('p');

    choiceParagraphElement.classList.add('choice');

    choiceParagraphElement.innerHTML = `<a href='#'>${choice.text}</a>`;

    storyScreen.appendChild(choiceParagraphElement);

    // Fade choice in after a short delay
    anime({
      targets: choiceParagraphElement,
      opacity: 1,
      duration: inDuration,
      delay: 300,
    });

    // Click on choice
    const choiceAnchorEl = choiceParagraphElement.querySelectorAll('a')[0];

    choiceAnchorEl.addEventListener('click', (event) => {
      // Don't follow <a> link
      event.preventDefault();

      // Remove all existing choices
      // const existingChoices = storyContainer.querySelectorAll('p.choice');
      //
      // existingChoices.forEach((existingChoice) => {
      //   const c = existingChoice;
      //
      //   c.parentNode.removeChild(c);
      // });

      storyContainer.removeChild(storyScreen);

      // Tell the story where to go next
      story.ChooseChoiceIndex(choice.index);

      // Aaand loop
      continueStory();
    });
  });
}

continueStory();

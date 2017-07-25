import { Story } from 'inkjs';
import json from './uber.json';

const story = new Story(json);
const storyContainer = document.getElementById('story');
const startButton = document.getElementById('start-button');

function showElements(arr) {
  arr.map((e) => {
    const elementToShow = e;

    elementToShow.style.display = 'block';

    return elementToShow;
  });
}

function hideElements(arr) {
  arr.map((e) => {
    const elementToHide = e;

    elementToHide.style.display = 'none';

    return elementToHide;
  });
}

function fadeInElements(arr, delay) {
  setTimeout(() => {
    arr.map((e) => {
      const elementToFadeIn = e;

      elementToFadeIn.style.opacity = 1;

      return elementToFadeIn;
    });
  }, delay);
}

function fadeOutElements(arr, delay) {
  setTimeout(() => {
    arr.map((e) => {
      const elementToFadeOut = e;

      elementToFadeOut.style.opacity = 0;

      return elementToFadeOut;
    });
  }, delay);
}

function startStory() {
  const tint = document.getElementsByClassName('tint')[0];
  const introScreen = document.getElementById('intro');
  const storyEl = document.getElementById('story');

  tint.classList.remove('pre-game');
  tint.classList.add('in-game');

  introScreen.style.opacity = '0';
  hideElements([introScreen]);

  setTimeout(() => showElements([storyEl]), 300);
}

startButton.onclick = startStory;

function continueStory() {
  // const paragraphIndex = 0;
  const storyScreen = document.createElement('div');
  const totalDisplay = document.getElementById('total');
  const total = story.variablesState.$('fares_earned_total');

  storyScreen.classList.add('screen');

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
    fadeInElements([paragraphElement], 300);
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create paragraph with anchor element
    const choiceParagraphElement = document.createElement('p');

    choiceParagraphElement.classList.add('choice');

    choiceParagraphElement.innerHTML = `<a href='#'>${choice.text}</a>`;

    storyScreen.appendChild(choiceParagraphElement);

    // Fade choice in after a short delay
    fadeInElements([choiceParagraphElement], 300);

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

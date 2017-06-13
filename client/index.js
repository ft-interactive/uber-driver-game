import { Story } from 'inkjs';
import json from './uber.json';

const story = new Story(json);
const storyContainer = document.getElementById('story');

function showAfter(delay, el) {
  setTimeout(() => {
    el.classList.add('show');
  }, delay);
}

function continueStory() {
  // const paragraphIndex = 0;
  const storyScreen = document.createElement('div');
  const totalDisplay = document.getElementById('total');
  const total = story.variablesState.$('fares_earned_total');
  const delay = 200;

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
    showAfter(delay, paragraphElement);
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create paragraph with anchor element
    const choiceParagraphElement = document.createElement('p');

    choiceParagraphElement.classList.add('choice');

    choiceParagraphElement.innerHTML = `<a href='#'>${choice.text}</a>`;

    storyScreen.appendChild(choiceParagraphElement);

    // Fade choice in after a short delay
    showAfter(delay, choiceParagraphElement);

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

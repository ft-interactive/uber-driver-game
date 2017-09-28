/**
 * Code for the ending segment
 */

import anime from 'animejs';
import {
  introScreen,
  storyScreen,
  defaultInDuration,
  defaultOutDuration,
  story,
} from '../../';

// Helper function for writing BEM-style classes
const blockName = 'ending';
const b = ([em]) => `${em ? '.' : ''}${blockName}${em ? `__${em}` : ''}`;

// Parent element
const endingScreen = document.getElementById(b``);

// Pages
const statsPage = document.querySelector(b`stats`);
const incomeAndCostsPage = document.querySelector(b`income-costs`);
const outcomesPage = document.querySelector(b`outcomes`);
const onwardJourneyPage = document.querySelector(b`social-share`);

// Interior elements
const continueButton = document.querySelector(b`continue-button`);
const endingPrimaryHeadline = document.querySelector(b`header-primary`);
const endingSecondaryHeadline = document.querySelector(b`header-secondary`);
const incomeAndCostsFigure = incomeAndCostsPage.querySelector(b`big-number`);


export default function endStory() {
  introScreen.style.display = 'none';
  storyScreen.style.display = 'none';
  endingScreen.style.display = 'flex';

  const showEndingScreen = anime.timeline();
  showEndingScreen.add({
    targets: [],
    opacity: 0,
    duration: defaultOutDuration,
    easing: 'linear',
    offset: 0,
    begin: () => {
    },
    complete: () => {
    },
  })
  .then(() => new Promise((resolve) => {
    endingPrimaryHeadline.textContent = 'Your income';
    incomeAndCostsFigure.textContent = parseInt(story.variablesState.$('revenue_total'), 10);

    const nextScreen = () => {
      resolve();
    };

    continueButton.addEventListener('click', nextScreen);
    continueButton.addEventListener('tap', nextScreen);
  }))
  .then(() => new Promise((resolve) => {
    endingPrimaryHeadline.textContent = 'Your costs';
    incomeAndCostsFigure.textContent = parseInt(story.variablesState.$('costs_total'), 10);

    const nextScreen = () => {
      resolve();
    };

    continueButton.addEventListener('click', nextScreen);
    continueButton.addEventListener('tap', nextScreen);
  }))
  .then(() => new Promise((resolve) => {
    const nextScreen = () => {
      resolve();
    };

    continueButton.addEventListener('click', nextScreen);
    continueButton.addEventListener('tap', nextScreen);
  }))
  .then(() => new Promise((resolve) => {
    const nextScreen = () => {
      resolve();
    };

    continueButton.addEventListener('click', nextScreen);
    continueButton.addEventListener('tap', nextScreen);
  }));
}

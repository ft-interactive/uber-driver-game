import { Story } from 'inkjs';
import anime from 'animejs';
import json from './uber.json';

const story = new Story(json);
const tint = document.querySelector('.tint');
const introScreen = document.getElementById('intro');
const storyScreen = document.getElementById('story');
const startButton = document.getElementById('start-button');
const shareButtons = document.querySelector('.article__share');
const footer = document.querySelector('.o-typography-footer');
const defaultInDuration = 1000;
const defaultOutDuration = 1500;

function startStory() {
  tint.classList.remove('pre-game');
  tint.classList.add('in-game');

  const fadeOutIntro = anime({
    targets: [introScreen, shareButtons, footer],
    opacity: 0,
    duration: defaultInDuration,
    easing: 'linear',
  });

  const fadeInGame = anime({
    targets: storyScreen,
    opacity: 1,
    duration: defaultOutDuration,
    easing: 'linear',
  });

  fadeOutIntro.update = (anim) => {
    if (anim.completed) {
      introScreen.style.display = 'none';
      shareButtons.style.display = 'none';
      footer.style.display = 'none';

      storyScreen.style.display = 'block';

      fadeInGame.play();
    }
  };
}

startButton.onclick = startStory;

function continueStory() {
  const knotElement = document.createElement('div');
  const totalDisplay = document.getElementById('total');
  const total = story.variablesState.$('fares_earned_total');

  knotElement.classList.add('knot');

  totalDisplay.innerHTML = total;

  // Generate story text - loop through available content
  while (story.canContinue) {
    // Get ink to generate the next paragraph
    const paragraphText = story.Continue();
    // Create paragraph element
    const paragraphElement = document.createElement('p');

    paragraphElement.innerHTML = paragraphText;

    knotElement.appendChild(paragraphElement);

    storyScreen.appendChild(knotElement);

    // Slide in paragraph after a short delay
    anime({
      targets: knotElement,
      marginTop: 0,
      duration: defaultInDuration,
      easing: 'easeOutQuad',
    });
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach((choice) => {
    // Create paragraph with anchor element
    const choiceElement = document.createElement('p');

    choiceElement.classList.add('choice');
    choiceElement.innerHTML = `<a href='#'>${choice.text}</a>`;

    knotElement.appendChild(choiceElement);

    const choiceAnchorEl = choiceElement.querySelector('a');

    // Click on choice
    function handleClick(event) {
      // Don't follow <a> link
      event.preventDefault();

      // Remove all existing choices
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
        marginTop: '100vh',
        duration: defaultOutDuration,
        delay: defaultOutDuration / 2,
        easing: 'easeOutQuad',
        complete: () => {
          storyScreen.removeChild(knotElement);
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

continueStory();

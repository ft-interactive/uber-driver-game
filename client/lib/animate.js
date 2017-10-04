// @flow

type Options = {
  duration?: number,
  ease?: number => number,
  delay?: number,
};

type FinalisedOptions = {
  duration: number,
  ease: number => number,
  delay: number,
};

type AnimateCallback = (elapsed: number) => void;

const linear = x => x;

const defaults = {
  ease: linear,
  duration: 1000,
  delay: 0,
};

const animate = (callback: AnimateCallback, _options?: Options): Promise<void> => {
  const options: FinalisedOptions = { ...defaults, ..._options };

  return new Promise((resolve) => {
    let startTime;

    const doFrame = (ms) => {
      // special case for zero duration
      if (options.duration === 0) {
        callback(1);
        resolve();
        return;
      }

      if (!startTime) startTime = ms;

      // determine how far we are through (between 0 and 1 inclusive)
      const delta = ms - startTime;
      let elapsed = delta / options.duration;
      elapsed = Math.min(elapsed, 1);

      if (isNaN(elapsed) || typeof elapsed !== 'number') {
        throw new Error('elapsed must be a number');
      }

      elapsed = options.ease(elapsed);

      // call the user's update function
      callback(elapsed);

      // draw next frame if appropriate, otherwise resolve
      if (elapsed < 1) requestAnimationFrame(doFrame);
      else {
        callback(1);
        resolve();
      }
    };

    setTimeout(() => {
      requestAnimationFrame(doFrame);
    }, Math.max(options.delay, 0));
  });
};

export default animate;

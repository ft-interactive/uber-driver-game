// @flow

type AnimateOptions = {
  duration: number,
  ease: number => number,
};

type AnimateCallback = (elapsedProportion: number) => void;

const linear = x => x;

const defaults = {
  ease: linear,
  duration: 1000,
};

const animate = (callback: AnimateCallback, _options?: any): Promise<void> => {
  const options: AnimateOptions = { ...defaults, ..._options };

  return new Promise((resolve) => {
    let startTime;

    const doFrame = (ms) => {
      if (!startTime) startTime = ms;

      // determine how far we are through (between 0 and 1 inclusive)
      const elapsedProportion = Math.min(options.ease((ms - startTime) / options.duration), 1);

      // call the user's update function
      callback(elapsedProportion);

      // draw next frame if appropriate, otherwise resolve
      if (elapsedProportion < 1) requestAnimationFrame(doFrame);
      else {
        callback(1);
        resolve();
      }
    };

    requestAnimationFrame(doFrame);
  });
};

export default animate;

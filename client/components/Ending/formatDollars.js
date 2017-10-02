// @flow

const formatDollars = (num: number, includeSign: boolean = false) => {
  let sign = '';
  if (includeSign || num < 0) {
    if (num < 0) sign = '– ';
    else sign = '+ ';
  }

  return `${sign}$${Math.round(Math.abs(num)).toLocaleString()}`;
};

export default formatDollars;

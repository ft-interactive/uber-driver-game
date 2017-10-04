// @flow

const formatDollars = (
  num: number,
  includeSign: boolean = false,
  includeCents: boolean = false,
) => {
  let sign = '';
  if (includeSign || num < 0) {
    if (num < 0) sign = '– ';
    else sign = '+ ';
  }

  let result = Math.abs(num);
  if (includeCents) {
    result = (Math.round(result * 100) / 100).toFixed(2);
  } else result = Math.round(result);

  return `${sign}$${result}`;
};

export default formatDollars;

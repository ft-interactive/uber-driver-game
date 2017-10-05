// @flow

const formatDollars = (
  num: number,
  alwaysIncludeSign: boolean = false,
  includeCents: boolean = false,
  negativeZero: boolean = false,
) => {
  let sign = '';
  if (alwaysIncludeSign || num < 0) {
    if (num < 0 || (negativeZero && num <= 0)) sign = '– ';
    else sign = '+ ';
  }

  let result = Math.abs(num);
  if (includeCents) {
    result = Number((Math.round(result * 100) / 100).toFixed(2));
  } else result = Math.round(result);

  return `${sign}$${result.toLocaleString()}`;
};

export default formatDollars;

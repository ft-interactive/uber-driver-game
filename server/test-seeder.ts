/**
 * Fills the database with a couple thousand fake games
 */

import { Result, Decision, sequelize } from './models';
import { map, all } from 'bluebird';

all([Result.sync({ force: true }), Decision.sync({ force: true })]).then(() => {
  const decisionTypes = [
    'biz_licence',
    'helped_homework',
    'took_day_off',
  ];
  const randEl = (arr: any[]) => arr[Math.floor(Math.random() * arr.length)];
  const randRange = (max: number, min: number) => Math.random() * (max - min) + min;

  map(Array(200000), (item: any, i: number) => Decision.create({
    type: randEl(decisionTypes),
    value: randEl([true, false]),
    difficulty: randEl(['hard', 'easy']),
    meta: {},
  }).then(() => {
    console.log(`Created decision ${i}`);
    return true;
  }), {
    concurrency: 5,
  });

  map(Array(50000), (item: any, i: number) => {
    const revenue = randRange(50, 2000);
    const expenses = randRange(100, 800);
    return Result.create({
      revenue,
      expenses,
      difficulty: randEl(['hard', 'easy']),
      hourlyWage: randRange(1, 20),
      income: revenue - expenses,
      meta: {},
    }).then(() => {
      console.log(`Created result ${i}`);
      return true;
    });
  }, {
    concurrency: 5,
  });
});

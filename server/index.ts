/**
 * Uber Game results service
 */

import micro, { json, send } from 'micro';
import { Result, Decision, sequelize } from './models';
import { IncomingMessage, ServerResponse } from 'http';
import { parse } from 'url';

Promise.all([Result.sync(), Decision.sync()])
.then(() => {
  const server = micro(async (req: IncomingMessage, res: ServerResponse) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'content-type,accept');
    if (req.method && req.method.toLowerCase() === 'options') {
      return {};
    }

    const path = parse(req.url || '');
    switch (path.pathname) {
      case '/decisions':
        if (req.method && req.method.toLowerCase() === 'post') {
          try {
            await Decision.create(await json(req));
            return 'Decision added';
          } catch (e) {
            console.error(e);
            send(res, 500, 'Server Error');
          }
        } else {
          const result: any = await Decision.findAndCountAll({ // The d.ts is wrong on this.
            attributes: ['type', 'value'],
            group: ['type', 'value'],
          });

          const { rows, count } = result;

          const reduced = rows.reduce((
            acc: DecisionResult, item: {type: string, value: 'true'|'false'}, idx: number) => {
            if (!acc[item.type]) acc[item.type] = {
              true: 0,
              false: 0,
            };
            acc[item.type][item.value] = Number(count[idx].count);

            return acc;
          }, <DecisionResult>{});

          return Object.assign({
            biz_licence: {
              true: 0,
              false: 0,
            },
            helped_homework: {
              true: 0,
              false: 0,
            },
            took_day_off: {
              true: 0,
              false: 0,
            },
          }, reduced);
        }
      case '/results':
        if (req.method && req.method.toLowerCase() === 'post') {
          try {
            await Result.create(await json(req));
            return 'Result added';
          } catch (e) {
            console.error(e);
            send(res, 500, 'Server Error');
          }
        }
      case '/ranking':
        try {
          const queryArgs = path.query.split('&')
            .map((frag: string) => frag.split('='));

          const [, difficulty] = queryArgs
            .find((item: string[]) => item[0] === 'difficulty');

          if (['easy', 'hard'].indexOf(difficulty) === -1) {
            throw new Error('Invalid difficulty detected');
          }

          const [, income] = queryArgs
            .find((item: string[]) => item[0] === 'income');

          return (await sequelize.query(
            `
            SELECT percent_rank(${Number(income)})
            WITHIN GROUP (ORDER BY income)
            FROM results
            WHERE difficulty = '${difficulty}';
            `,
            {
              type: sequelize.QueryTypes.SELECT,
            })).shift();
        } catch (e) {
          console.error(e);
          send(res, 500, 'Server Error');
        }
    }

    send(res, 500, 'Invalid route');
  });

  server.listen(process.env.PORT || 3000, () => {
    console.log(`Listening on ${process.env.PORT || 3000}`);
  });
});

interface DecisionResult {
  [key: string]: {
    true: number;
    false: number;
  };
}

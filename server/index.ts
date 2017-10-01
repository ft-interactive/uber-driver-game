/**
 * Uber Game results service
 */

import micro, { json, send } from 'micro';
import { Result, Decision, sequelize } from './models';
import { IncomingMessage, ServerResponse } from 'http';

Promise.all([Result.sync(), Decision.sync()])
.then(() => {
  const server = micro(async (req: IncomingMessage, res: ServerResponse) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'content-type,accept');
    if (req.method && req.method.toLowerCase() === 'options') {
      return {};
    }
    switch (req.url) {
      case '/decisions':
        console.log(req.method);
        if (req.method && req.method.toLowerCase() === 'post') {
          try {
            await Decision.create(await json(req));
            return 'Decision added';
          } catch (e) {
            console.error(e);
            send(res, 500, 'Server Error');
          }
        } else {
          return await Decision.findAll({
            attributes: [sequelize.fn('count', '*')],
            group: ['type', 'value'],
          });
        }
      case '/results':
        if (req.method && req.method.toLowerCase() === 'post') {
          try {
            await Result.create(await json(req));
            return await sequelize.query(
              `
              SELECT unnest(
                         percentile_cont(array[.1,.2,.3,.4,.5,.6,.7,.8,.9,1])
                         WITHIN GROUP (ORDER BY income)
                     )
              FROM results;
              `,
              {
                type: sequelize.QueryTypes.SELECT
              });
          } catch (e) {
            console.error(e);
            send(res, 500, 'Server Error');
          }
        }
    }

    send(res, 500, 'Invalid route');
  });

  server.listen(process.env.PORT || 3000, () => {
    console.log(`Listening on ${process.env.PORT || 3000}`);
  });
});

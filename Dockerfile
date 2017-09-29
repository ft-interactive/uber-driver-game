FROM node:alpine

ADD ./server /project

WORKDIR /project

RUN npm install

CMD [ "npm", "start" ]

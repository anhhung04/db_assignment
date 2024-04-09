FROM node:21-alpine3.18

WORKDIR /app

COPY bin /app/bin
COPY src /app/src
COPY package.json /app

RUN npm install --frozen-lockfile --skip-integrity-check

CMD ["npm", "run", "start"]
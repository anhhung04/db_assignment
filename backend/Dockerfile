FROM node:21-alpine3.18

WORKDIR /app

ENV NODE_ENV=production

COPY bin /app/bin
COPY src /app/src
COPY package.json /app
COPY entrypoint.sh /app
RUN chmod +x /app/entrypoint.sh

RUN npm install

CMD ["./entrypoint.sh"]
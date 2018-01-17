FROM "node:6-alpine"

EXPOSE 3000

RUN apk add --update tini

RUN mkdir -p /code

WORKDIR /code

ADD . /code

RUN npm set progress=false && \
    npm install -s --no-progress && \
    npm prune --production 

CMD ["tini", "--", "npm", "start"]

FROM "node:6-alpine"

RUN mkdir -p /code

WORKDIR /code

ADD . /code

RUN npm set progress=false && \
    npm install -s --no-progress && \
    npm prune --production 

CMD ["npm", "start"]

EXPOSE 3000
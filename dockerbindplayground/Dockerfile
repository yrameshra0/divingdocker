FROM ruby:2.4.2-alpine

RUN apk add --no-cache build-base gcc bash

RUN gem install jekyll bundler

EXPOSE 4000

WORKDIR /site

ENV JEKYLL_NEW false

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]
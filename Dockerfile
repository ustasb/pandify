FROM ruby:2.4.1-alpine3.6
MAINTAINER Brian Ustas <brianustas@gmail.com>

ARG APP_PATH="/opt/pandify"

RUN apk add --update \
  build-base \
  nodejs \
  ruby-dev \
  tzdata \
  postgresql-dev \
  && rm -rf /var/cache/apk/*

WORKDIR $APP_PATH

# Add Gemfile and Gemfile.lock first for caching.
COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH
RUN bundle install

COPY . $APP_PATH
VOLUME $APP_PATH
EXPOSE 3000

ENTRYPOINT ["sh", "bin/deploy"]
CMD ["rails", "server", "-b", "0.0.0.0"]

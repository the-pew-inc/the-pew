FROM ruby:3.1.2-alpine AS builder
ENV RAILS_ENV=production \
  NODE_ENV=production

RUN apk add --no-cache --update \
  build-base zlib-dev git yarn gcompat \
  postgresql-dev libffi-dev vips-dev \
  && mkdir app

WORKDIR /app
COPY Gemfile* package.json yarn.lock ./

RUN gem install --no-document --no-user-install rails -v 7.0.4 \
  gem install --no-document --no-user-install bundler \
  && bundle config set --without "development test" \
  && bundle install \
  && yarn install


# Production image based on the build image
FROM ruby:3.1.2-alpine AS runner

ENV RAILS_ENV=production \
  NODE_ENV=production

ARG DATABASE_POOL \
  DATABASE_URL \
  DEFAULT_URL \
  DISABLE_DATABASE_ENVIRONMENT_CHECK \
  DO_ENDPOINT \
  DO_ACCESS_KEY_ID \
  DO_SECRET_ACCESS_KEY \
  DO_BUCKET \
  GOOGLE_CLIENT_ID \
  GOOGLE_CLIENT_SECRET \
  HONEYBADGER_API_KEY \
  REDISCLOUD_URL \
  SENDGRID_API_KEY \
  SIDEKIQ_AUTH_PASSWORD \
  SIDEKIQ_AUTH_USERNAME

RUN apk add --no-cache --update \
  tzdata nodejs vips-dev \
  libffi-dev postgresql-client \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN mkdir app
WORKDIR /app

# We copy over the entire gems directory for our builder image, containing the already built artifact
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]



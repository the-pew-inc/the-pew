FROM ruby:3.1.2-alpine AS builder
ENV RAILS_ENV=production \
  NODE_ENV=production

ARG RAILS_MASTER_KEY

# Add Alpine packages
RUN apk add --no-cache --update \
  build-base zlib-dev git yarn gcompat \
  postgresql-dev libffi-dev vips-dev tzdata \
  && mkdir app

WORKDIR /app
COPY Gemfile* package.json yarn.lock ./

# Add the Rails app
ADD . /app

RUN gem install --no-document --no-user-install rails -v 7.0.4 \
  && gem install --no-document --no-user-install bundler \
  && bundle config set --local 'development test' \
  && bundle install --without -j4 --retry 3 \
  && bundle exec rake assets:precompile \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete \
  && yarn install \
  && rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec \
  && apk del --rdepends --purge build-base 


# Production image based on the build image
FROM ruby:3.1.2-alpine AS runner

ENV RAILS_ENV=production \
  NODE_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  EXECJS_RUNTIME=Disabled

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
  RAILS_MASTER_KEY \
  REDISCLOUD_URL \
  SENDGRID_API_KEY \
  SIDEKIQ_AUTH_PASSWORD \
  SIDEKIQ_AUTH_USERNAME

# Add Alpine packages
RUN apk add --no-cache --update \
  tzdata nodejs vips-dev \
  libffi-dev postgresql-client \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN mkdir app

# Copy app with gems from former build stage
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app

WORKDIR /app

EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

CMD ["rails", "server", "-b", "0.0.0.0"]



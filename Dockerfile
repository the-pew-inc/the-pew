FROM ruby:3.3.0-alpine AS builder
ENV RAILS_ENV=production

ARG RAILS_MASTER_KEY
ARG APP_ROLE=web

# Add Alpine packages
RUN apk add --no-cache --update \
  build-base zlib-dev git yarn gcompat \
  postgresql-dev libffi-dev vips-dev tzdata \
  && mkdir app

WORKDIR /app
COPY Gemfile* package.json yarn.lock esbuild.config.js ./

# Add the Rails app
ADD . /app

RUN gem install --no-document --no-user-install rails -v 7.1.2 \
  && gem install --no-document --no-user-install bundler \
  && bundle config set deployment 'true' \
  && bundle config set --local without 'development test' \
  && bundle config set path 'vendor/bundle' \
  && bundle lock --add-platform aarch64-linux-musl x86_64-linux \
  && bundle install -j4 --retry 3 \
  && yarn install \
  && bundle exec rake assets:precompile \
  && bundle clean --force \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete \
  && rm -rf node_modules tmp/cache  \
  && apk del --rdepends --purge build-base 


# Production image based on the build image
FROM ruby:3.3.0-alpine AS runner

ENV RAILS_ENV=production \
  NODE_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  EXECJS_RUNTIME=Disabled \
  RUBY_YJIT_ENABLE=true

ARG DATABASE_POOL \
  DATABASE_URL \
  DEFAULT_URL \
  DISABLE_DATABASE_ENVIRONMENT_CHECK \
  DO_ACCESS_KEY_ID \
  DO_BUCKET \
  DO_ENDPOINT \
  DO_SECRET_ACCESS_KEY \
  GOOGLE_CLIENT_ID \
  GOOGLE_CLIENT_SECRET \
  HONEYBADGER_API_KEY \
  OPENAI_ACCESS_TOKEN \
  OPENAI_ORGANIZATION_ID \
  RAILS_MASTER_KEY \
  REDISCLOUD_URL \
  SENDGRID_API_KEY \
  SIDEKIQ_AUTH_PASSWORD \
  SIDEKIQ_AUTH_USERNAME

# Add Alpine packages
RUN apk add --no-cache --update \
  tzdata nodejs vips-dev ca-certificates \
  libffi-dev postgresql-client \
  && bundle config set --local without 'development test' \
  && bundle config set path 'vendor/bundle' \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN mkdir app

# Copy app with gems from former build stage
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app

WORKDIR /app

EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Conditional CMD based on APP_ROLE
CMD if [ "$APP_ROLE" = "web" ]; then \
  rails server -b 0.0.0.0; \
  else \
  bundle exec sidekiq -e production -C config/sidekiq.yml; \
  fi

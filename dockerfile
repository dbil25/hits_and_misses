####################################################################################################
# This dockerfile is used as the base image for the
# rails app and the sidekiq worker images. We keep
# a seprate Dockerfile while we migrate to k8s
####################################################################################################

####################################################################################################
# Stage: build
####################################################################################################
FROM ruby:3.1-alpine as Builder

####################################################################################################
# Defaults
####################################################################################################
ARG APP_ENV=integration
ARG RAILS_ENV=production
ARG RAILS_MASTER_KEY
ARG BUNDLE_CONTRIBSYS
ARG BUNDLE_GITHUB

ENV APP_ENV ${APP_ENV}
ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}
ENV REDIS_URL "dummy.url.com"
ENV DATABASE_URL "dummy.url.com"
ENV REPLICATION_DATABASE_URL "REPLICATION_DATABASE_URL"
ENV AWS_REGION "ci"
ENV AWS_UPLOADS_BUCKET "ci"
ENV AWS_DATA_BUCKET "ci"

RUN apk upgrade && apk add --update \
  bash \
  build-base \
  gcompat \
  git \
  postgresql-dev \
  && rm -rf /var/cache/apk/*

WORKDIR /app
ADD Gemfile* /app/

# Install bundler
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle config --global without "development test"
RUN bundle config --global clean true
RUN bundle config set --local deployment 'true'
RUN bundle install --jobs 5 --retry 5

# Remove useless files, i.e.: cached *.gem, *.o, *.c
RUN rm -rf /usr/local/bundle/cache/*.gem
RUN find /usr/local/bundle/gems/ -name "*.c" -delete
RUN find /usr/local/bundle/gems/ -name "*.o" -delete

# Add the Rails app
ADD . /app

# Precompile assets
RUN bundle exec rake assets:precompile
# FIXME: Somehow need to do it twice to get the assets to work
RUN bundle exec rake assets:precompile
CMD ["/bin/sh", "./bin/infrastructure/start_web"]
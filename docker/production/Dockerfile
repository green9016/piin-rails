FROM ruby:2.5.3-alpine

RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  tzdata \
  nodejs \
  imagemagick \
  git

ENV APP_HOME /app

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV RAILS_ENV production
ENV RACK_ENV production
ENV RAILS_LOG_TO_STDOUT true

ENV APP_NAME "PIN API"
ENV RAILS_MAX_THREADS 5
ENV WEB_CONCURRENCY 2
ENV DB_REAPING_FREQUENCY 10
ENV CLIENT_URL "http://localhost:4200"
ENV PORT 3000
ENV WORKER_TIMEOUT 3600

RUN gem install bundler -v '2.0.1'
RUN bundle config --global frozen 1
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5 --without development test

COPY . .

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb

# https://itnext.io/docker-rails-puma-nginx-postgres-999cd8866b18
# http://blog.scoutapp.com/articles/2018/01/02/dockerizing-a-rails-app
# https://www.engineyard.com/blog/using-docker-for-rails
# https://medium.com/firehydrant-io/developing-a-ruby-on-rails-app-with-docker-compose-d75b20334634
# https://blog.codeship.com/deploying-docker-rails-app/

# https://www.engineyard.com/blog/kubernetes-tutorial-running-a-rails-app-in-kubernetes

# https://cloud.google.com/ruby/tutorials/bookshelf-on-kubernetes-engine
# https://cloud.google.com/solutions/continuous-delivery-jenkins-kubernetes-engine

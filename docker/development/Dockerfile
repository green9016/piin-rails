FROM ruby:2.5.3-alpine

RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  tzdata \
  imagemagick

ENV APP_HOME /app

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler -v '2.0.1'
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5 --without production

COPY . .

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb

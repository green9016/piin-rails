FROM gcr.io/pinapp-222219/pin-backend-production

ENV RAILS_ENV staging
ENV RACK_ENV staging
ENV RAILS_LOG_TO_STDOUT true

ENV APP_NAME "PIN API"
ENV RAILS_MAX_THREADS 5
ENV WEB_CONCURRENCY 2
ENV DB_REAPING_FREQUENCY 10
ENV CLIENT_URL "http://storage.googleapis.com"
ENV PORT 3000
ENV WORKER_TIMEOUT 3600
ENV REDIS_URL redis://localhost:6379/1

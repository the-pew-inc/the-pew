release: bin/rails db:migrate
web: bin/rails server -p $PORT
worker: bundle exec sidekiq -c 1
console: bundle exec bin/rails console
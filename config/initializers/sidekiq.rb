# frozen_string_literal: true

uri = ENV.fetch('REDISCLOUD_URL', 'redis://localhost:6379/1')

Sidekiq.configure_server do |config|
  config.redis = { url: uri }
end
Sidekiq.configure_client do |config|
  config.redis = { url: uri }
end
# frozen_string_literal: true

URI = ENV.fetch('REDISCLOUD_URL', 'redis://localhost:6379/1')
REDISCLOUD_POOL_SIZE = ENV.fetch('REDISCLOUD_POOL_SIZE', 10)

# Configuring Redis Connection Pool
REDIS_POOL = ConnectionPool.new(size: REDISCLOUD_POOL_SIZE) { Redis.new(url: URI) }

Sidekiq.configure_server do |config|
  config.redis = REDIS_POOL
end
Sidekiq.configure_client do |config|
  config.redis = REDIS_POOL
end
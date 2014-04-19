Sidekiq.configure_server do |config|
  config.redis = { namespace: 'prog_judge' }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'prog_judge' }
end
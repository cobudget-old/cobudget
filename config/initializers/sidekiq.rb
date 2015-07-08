Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/5', namespace: "activejob-sample" }

  config.server_middleware do |chain|
     chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 0
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/5', namespace: "activejob-sample" }
end
Delayed::Worker.max_attempts = 2

# (EL) commented out because i actually don't want scheduled jobs to execute immediately when i'm developing or testing.
  # later on, i can probably make a test helper that causes all enqueued jobs to execute, if needed.
# Delayed::Worker.delay_jobs = !(Rails.env.test? or Rails.env.development?)
HealthCheck.setup do |config|
  # uri prefix (no leading slash)
  config.uri = 'health'

  # Text output upon success
  config.success = 'success'
end
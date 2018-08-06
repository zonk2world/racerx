Airbrake.configure do |config|
  config.api_key = '501fc7589a98426d6a3a270ff9b6010d'
  config.host    = 'errors.12spokes.com'
  config.port    = 443
  config.secure  = config.port == 443
  config.environment_name = ENV['ERRBIT_ENV'] || Rails.env
end
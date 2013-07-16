if Rails.env.test? || Rails.env.development?
  BuildNotifier::Application.config.secret_token = "66ae865b55a921012b6dabdb84b74360e2ed163b9625b63374d52278215c757ef27fd7166292600c0d500379b16a57bb8dac210da7cfe1479769bdc2921f9771"
else
  raise "You must set a secret token in ENV['SECRET_TOKEN'] or in config/initializers/secret_token.rb" if ENV['SECRET_TOKEN'].blank?
  BuildNotifier::Application.config.secret_token = ENV['SECRET_TOKEN']
end

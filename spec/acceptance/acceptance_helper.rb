require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|
  Capybara.server = :puma
  Capybara.javascript_driver = :webkit
  Capybara.default_max_wait_time  = 5

  config.include AcceptanceHelper, type: :feature
  config.include OmniauthMacros, type: :feature
  OmniAuth.config.test_mode = true

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
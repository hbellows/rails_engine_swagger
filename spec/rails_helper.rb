require 'simplecov'
SimpleCov.start

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  config.fuubar_progress_bar_options = { 
    :format => "%a %b\u{15E7}%i %p%% %t",
    :progress_mark  => ' ',
    :remainder_mark => "\u{FF65}"
  }
end

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.before(:all) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end  
end

# VCR.configure do |config|
#   config.cassette_library_dir = "fixtures/vcr_cassettes"
#   config.hook_into :webmock
#   config.filter_sensitive_data('<YOUR XXX API KEY HERE>') { ENV['xxx_api_key'] }
# end
require 'bundler/setup'
require 'active_record'
require 'database_cleaner'
require 'rails'

Bundler.setup

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load File.dirname(__FILE__) + '/schema.rb'

require 'global_configuration'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      Rails.cache = ActiveSupport::Cache::MemoryStore.new
      example.run
    end
  end
end
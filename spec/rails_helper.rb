ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails' # Rails must be required first

RSpec.configure do |config|
  config.order = :random
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

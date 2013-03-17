require 'rspec'
require 'sensu-apihelper'
require 'webmock/rspec'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = 'documentation'
end

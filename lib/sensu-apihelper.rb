require "sensu-apihelper/version"
require "sensu-apihelper/client"
require "sensu-apihelper/check"
require "sensu-apihelper/event"
require "sensu-apihelper/check_status"

module Sensu
  module Apihelper
    def self.api_url(url)
      $api_url = url
    end
  end
end

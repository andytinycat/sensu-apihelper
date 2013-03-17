require 'json'
require 'rest-client'

module Sensu
  module Apihelper
    class Event

      attr_accessor :client, :check, :occurrences, :output, :flapping, :status, :issued

      def self.get_by_client_and_check(client, check)
        json = Net::HTTP.get URI("#{$api_url}/events/#{client}/#{check}")
        if json != ""
          Event.new(JSON.parse json)
        else
          nil
        end
      end

      def initialize(json)
        @client      = Client.get_by_name(json["client"])
        @check       = json["check"]
        @occurrences = json["occurrences"]
        @output      = json["output"]
        @flapping    = json["flapping"]
        @status      = json["status"]
        @issued      = json["issued"]
      end

    end
  end
end

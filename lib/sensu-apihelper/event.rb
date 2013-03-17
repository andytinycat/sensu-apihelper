require 'json'
require 'rest-client'

module Sensu
  module Apihelper
    class Event

      attr_accessor :client, :check, :occurrences, :output, :flapping, :status, :issued

      def self.get_all
        json = JSON.parse Net::HTTP.get URI("#{$api_url}/events")
        if json != ""
          json.map do |event_json|
            Event.new(event_json)
          end
        end
      end

      def self.get_by_client_and_check(client, check)
        json = Net::HTTP.get URI("#{$api_url}/events/#{client}/#{check}")
        if json != ""
          Event.new(JSON.parse json)
        else
          nil
        end
      end

      def initialize(json)
        @client      = json["client"]
        @check       = json["check"]
        @occurrences = json["occurrences"]
        @output      = json["output"].chomp
        @flapping    = json["flapping"]
        @status      = json["status"]
        @issued      = json["issued"]
      end

      def inspect
        "#{self.check} on #{self.client}: Output '#{output}', status #{status}, at #{issued}"
      end

      def to_s
        inspect
      end

    end
  end
end

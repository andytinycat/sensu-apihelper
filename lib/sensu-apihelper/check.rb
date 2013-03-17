require 'rest-client'
require 'net/http'
require 'json'

module Sensu
  module Apihelper
    class Check

      attr_accessor :command, :subscribers, :interval, :occurrences, :name

      def self.get_by_subscription(subscription)
        json = JSON.parse Net::HTTP.get URI($api_url + "/checks")
        json.map do |check_json|
          if check_json["subscribers"].include?(subscription)
            Check.new(check_json)
          end
        end
      end

      def initialize(json)
        @command      = json["command"]
        @subscribers  = json["subscribers"]
        @interval     = json["interval"]
        @occurrences  = json["occurrences"]
        @name         = json["name"]
      end

      def inspect
        "#{@name}: command = #{@command}, subscribers = #{@subscribers.join(";")}, interval = #{@interval}, occurrences = #{@occurrences}, name = #{@name}"
      end

      def to_s
        inspect
      end

      def method_missing(attribute)
        @json[attribute.to_s] || nil
      end

    end
  end
end

require 'rest_client'
require 'net/http'
require 'json'

module Sensu
  module Apihelper

    # Representation of a Sensu client.
    
    class Client

      attr_accessor :name, :ip, :subscriptions, :last_check_in, :check_statuses

      # Return all Sensu clients.
      def self.get_all
        json = JSON.parse Net::HTTP.get URI($api_url + "/clients")
        json.map do |client_json|
          Client.new(client_json)
        end
      end

      # Get a client by name.
      def self.get_by_name(name)
        json = JSON.parse Net::HTTP.get URI($api_url + "/clients/#{name}")
        Client.new(json)
      end

      # Create a new Sensu client from the JSON return from the Sensu API.
      def initialize(json)
        # Massage into a hash for speed and convenience
        history_json    = JSON.parse Net::HTTP.get URI("#{$api_url}/clients/#{json["name"]}/history")
        @history_data   = Hash[history_json.map { |h| [h["check"], h] }]
        @name           = json["name"]
        @ip             = json["address"]
        @subscriptions  = json["subscriptions"]
        @last_check_in  = json["timestamp"]
        @json           = json
        @check_statuses = checks.map do |check|
          CheckStatus.new(self.name, check.name, @history_data)
        end
      end

      def checks
        checks = @subscriptions.map do |subscription|
          Check.get_by_subscription(subscription) 
        end
        checks.flatten
      end

      # Look up custom client attributes.
      def [](key)
        case key.class
        when Symbol
          @json[key.to_s]
        when String
          @json[key]
        end
      end

    end
  end
end

require 'json'
require 'rest-client'

module Sensu
  module Apihelper
    class CheckStatus

      attr_accessor :name, :client, :status, :message, :timestamp

      def initialize(client_name, check_name, history_data)
        event = Event.get_by_client_and_check(client_name, check_name)
        if event == nil # A check that is succeeding has no event associated with it
          @status       = history_data[check_name]["last_status"]
          @timestamp    = history_data[check_name]["last_execution"]
          @message      = "OK"
          @name         = check_name
          @client       = client_name
          @occurrences  = 1
        else
          @status       = event.status
          @timestamp    = event.issued
          @message      = event.output.chomp
          @name         = check_name
          @client       = client_name
          @occurrences  = event.occurrences
        end
      end

      def inspect
        "#{@client} - #{@name}: status #{@status} with message '#{@message}' at #{@timestamp}, #{@occurrences} occurrences"
      end

      def to_s
        inspect
      end

      def warning?
        @status == 1 || false
      end

      def critical?
        @status == 2 || false
      end

      def ok?
        @status == 0 || false
      end

      def unknown?
        @status == 3 || false
      end

    end
  end
end

# frozen_string_literal: true

module SimpleTools
  module Events
    class Subscriber
      attr_reader :event_name, :payload

      def self.notify(event_name, payload)
        new(event_name, payload).call
      end

      def initialize(event_name, payload)
        @event_name = event_name
        @payload = payload
      end

      def call
        handle
      end
    end
  end
end

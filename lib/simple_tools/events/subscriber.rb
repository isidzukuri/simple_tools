# frozen_string_literal: true

module SimpleTools
  module Events
    class Subscriber
      BehaviourNotDefined = Class.new(StandardError)

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

      private

      def handle
        raise(BehaviourNotDefined, 'Implement :handle method in your subscriber class')
      end
    end
  end
end

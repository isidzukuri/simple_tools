# frozen_string_literal: true

module SimpleTools
  module Events
    class Subscribers
      include Singleton

      def add(event_name, subscriber_class)
        !!list.add?(event_name: event_name, subscriber_class: subscriber_class)
      end

      def remove_by_event!(event_name)
        !!list.reject! { |item| item[:event_name] == event_name }
      end

      def remove_by_subscriber!(subscriber_class)
        !!list.reject! { |item| item[:subscriber_class] == subscriber_class }
      end

      def select(event_name)
        list.select { |item| item[:event_name] == event_name }
      end

      def to_a
        list.to_a
      end

      private

      def list
        @list ||= Set[]
      end
    end
  end
end

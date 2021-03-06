# frozen_string_literal: true

require 'set'
require 'singleton'
require 'simple_tools/events/subscriber'
require 'simple_tools/events/subscribers'

module SimpleTools
  module Events
    def self.subscribers
      Subscribers.instance
    end

    def self.subscribe(event_name, subscriber_class)
      subscribers.add(event_name, subscriber_class)
    end

    def self.publish(event_name, payload = nil)
      subscribers.select(event_name).each do |subscriber|
        subscriber[:subscriber_class].notify(event_name, payload)
      end
    end
  end
end

# frozen_string_literal: true

ENV['ENV'] ||= 'test'
require_relative '../lib/simple_tools'

RSpec.configure do |config|
  config.after(:each) do
    clear_subscribers
  end
end

def clear_subscribers
  subscribers = SimpleTools::Events::Subscribers.instance
  events = subscribers.to_a.map { |i| i[:event_name] }
  events.each { |name| subscribers.remove_by_event!(name) }
end

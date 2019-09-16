# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleTools::Events::Subscribers do
  let(:event_name) { 'event_fired' }
  let(:instance) { described_class.instance }
  let(:class_const) { Class }

  describe '.new' do
    it 'is singleton' do
      expect { described_class.new }.to raise_error(NoMethodError)
      expect(instance).to be_a(described_class)
    end
  end

  describe '.add' do
    it 'returns true on success' do
      expect(instance.add(event_name, class_const)).to be_truthy
      expect(instance.to_a).to eq([{
                                    event_name: event_name,
                                    subscriber_class: class_const
                                  }])
    end

    it 'returns false on failure, if event already registered' do
      expect(instance.add(event_name, class_const)).to be_truthy
      expect(instance.add(event_name, class_const)).to be_falsey
    end
  end

  describe '.remove_by_event' do
    it 'returns true on success' do
      instance.add(event_name, class_const)

      expect(instance.remove_by_event!(event_name)).to be_truthy
    end

    it 'returns true on failure' do
      expect(instance.remove_by_event!(event_name)).to be_falsey
    end
  end

  describe '.remove_by_subscriber' do
    it 'returns true on success' do
      instance.add(event_name, class_const)

      expect(instance.remove_by_subscriber!(class_const)).to be_truthy
    end

    it 'returns true on failure' do
      expect(instance.remove_by_subscriber!(class_const)).to be_falsey
    end
  end

  describe '.select' do
    it 'selects array of subscribers by event name' do
      instance.add(event_name, class_const)

      expect(instance.select(event_name)).to eq([{
                                                  event_name: event_name,
                                                  subscriber_class: class_const
                                                }])
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleTools::Events do
  let(:event_name) { 'event_fired' }
  let(:payload) { { some: 'data' } }

  describe '.subscribers' do
    it 'returns subscribers object' do
      expect(described_class.subscribers).to be_an_instance_of(SimpleTools::Events::Subscribers)
    end
  end

  describe '.subscribe' do
    it 'adds subscription of class to event' do
      result = described_class.subscribe('random event', 'SomeClass')

      expect(result).to be_truthy
    end
  end

  describe '.publish' do
    it 'notify all subsribers about published event' do
      expect_any_instance_of(SimpleTools::Events::Subscribers).to receive(:select).with(event_name).and_call_original

      result = described_class.publish(event_name, payload)

      expect(result).to eq([])
    end

    context 'with not emty subscribers list' do
      DummySubscriber = Class.new(SimpleTools::Events::Subscriber)

      before do
        described_class.subscribe(event_name, DummySubscriber)
      end

      it 'notify all subsribers about published event' do
        expect_any_instance_of(SimpleTools::Events::Subscribers).to receive(:select).with(event_name).and_call_original
        expect(DummySubscriber).to receive(:new).with(event_name, payload).and_call_original
        expect_any_instance_of(DummySubscriber).to receive(:handle)

        result = described_class.publish(event_name, payload)

        expect(result).to eq([{ event_name: event_name, subscriber_class: DummySubscriber }])
      end
    end
  end
end

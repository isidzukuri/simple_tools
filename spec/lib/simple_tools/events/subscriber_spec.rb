# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleTools::Events::Subscriber do
  let(:event_name) { 'event_fired' }
  let(:payload) { { some: 'data' } }

  describe '.notify' do
    it 'raises error about not definet method' do
      expect { described_class.notify(event_name, payload) }.to raise_error(SimpleTools::Events::Subscriber::BehaviourNotDefined)
    end

    it 'executes call method of instance' do
      expect_any_instance_of(described_class).to receive(:call)

      described_class.notify(event_name, payload)
    end
  end
end

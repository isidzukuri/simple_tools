# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleTools::Operation, type: :operation do
  describe '.call' do
    class NoStepsOperation < SimpleTools::Operation
    end

    class TwoStepsOperation < SimpleTools::Operation
      step :step_one
      step :step_two

      def step_one
        update_context(:first_var, '1 one')
      end

      def step_two
        update_context(:second_var, context[:first_var])
      end
    end

    it 'raises exception if steps are not defined' do
      expect { NoStepsOperation.call }.to raise_error(ArgumentError, 'steps are not defined')
    end

    it 'invokes each step' do
      expect_any_instance_of(TwoStepsOperation).to receive(:step_one)
      expect_any_instance_of(TwoStepsOperation).to receive(:step_two)

      result = TwoStepsOperation.call

      expect(result.success?).to eq true
    end

    it 'shares container context with every step' do
      result = TwoStepsOperation.call

      expect(result.success?).to eq true
      expect(result.context[:first_var]).to eq '1 one'
      expect(result.context[:second_var]).to eq '1 one'
    end

    context 'operation with errors' do
      class OneErrorOperation < SimpleTools::Operation
        step :step_one
        step :step_two
        def step_one
          error!('key', 'message')
        end

        def step_two; end
      end

      class ManyErrorsOperation < SimpleTools::Operation
        step :step_one
        step :step_two
        def step_one
          errors!(key: ['message'])
        end

        def step_two; end
      end

      it 'raises exception if steps are not defined' do
        expect_any_instance_of(OneErrorOperation).to receive(:step_one).and_call_original
        expect_any_instance_of(OneErrorOperation).not_to receive(:step_two)

        result = OneErrorOperation.call

        expect(result.success?).to eq false
        expect(result.errors).to eq(key: ['message'])
      end

      it 'raises exception if steps are not defined' do
        expect_any_instance_of(ManyErrorsOperation).to receive(:step_one).and_call_original
        expect_any_instance_of(ManyErrorsOperation).not_to receive(:step_two)

        result = ManyErrorsOperation.call

        expect(result.success?).to eq false
        expect(result.errors).to eq(key: ['message'])
      end

      context 'not valid errors' do
        class EmptyKeyOperation < SimpleTools::Operation
          step :step_one
          def step_one
            error!('', 'message')
          end
        end

        class EmptyMessageOperation < SimpleTools::Operation
          step :step_one
          def step_one
            error!('key', '')
          end
        end

        class ManyMessagesOperation < SimpleTools::Operation
          step :step_one
          def step_one
            errors!(['message'])
          end
        end

        it 'raises exception if steps are not defined' do
          expect { EmptyKeyOperation.call }.to raise_error(ArgumentError, 'key can not be empty')
        end

        it 'raises exception if steps are not defined' do
          expect { EmptyMessageOperation.call }.to raise_error(ArgumentError, 'message can not be empty')
        end

        it 'raises exception if steps are not defined' do
          expect { ManyMessagesOperation.call }.to raise_error(ArgumentError, 'hash should be given')
        end
      end
    end
  end
end

# frozen_string_literal: true

module SimpleTools
  class Operation
    attr_reader :params, :errors, :context

    class << self
      attr_reader :steps

      def call(params = {})
        instance = new(params)
        instance.call
        instance
      end

      def step(key)
        raise(ArgumentError, 'symbol should be given') unless key.is_a?(Symbol)

        (@steps ||= []).push(key.to_sym)
      end
    end

    def initialize(params)
      @errors = {}
      @context = {}
      @params = params
    end

    def call
      raise(ArgumentError, 'steps are not defined') unless self.class.steps

      self.class.steps.each do |step|
        public_send(step)
        break unless success?
      end
    end

    def success?
      errors.empty?
      # force developer to write descriptions of errors
    end

    def failure?
      !success?
    end

    private

    def update_context(key, value)
      raise(ArgumentError, 'key can not be empty') unless present?(key)

      @context[key] = value
    end

    def errors!(messages)
      raise(ArgumentError, 'hash should be given') unless messages.is_a?(Hash)

      messages.each do |key, value|
        raise(ArgumentError, 'hash with array values should be given') unless value.is_a?(Array)

        (@errors[key.to_sym] ||= []).push(*value)
      end
    end

    def error!(key, message)
      raise(ArgumentError, 'key can not be empty') unless present?(key)

      raise(ArgumentError, 'message can not be empty') unless present?(message)

      (@errors[key.to_sym] ||= []).push(message.to_s)
    end

    def present?(value)
      value.respond_to?(:empty?) ? !value.empty? : !!value
    end
  end
end

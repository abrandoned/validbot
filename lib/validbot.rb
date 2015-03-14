require "validbot/version"
require 'active_model'

module Validbot

  def self.validate(object, &block)
    ::Validbot::Validator.new(object, &block)
  end

  class Validator
    def self.validate(object, &block)
      self.new(object, &block)
    end

    def initialize(object, &block)
      klass(object).class_eval do
        include ::ActiveModel::Validations
      end

      klass(object).class_eval(&block)
      self
    end

    private

    def klass(object)
      class << object
        self
      end
    end
  end

end

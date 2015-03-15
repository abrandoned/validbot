require 'spec_helper'

describe Validbot do
  class DerpDerp < Struct.new(:derp, :version, :title)
    include ActiveModel::Model
  end

  let (:derp) { DerpDerp.new }

  it 'validates presence' do
    Validbot.validate(derp) do
      validates :derp, :presence => true
    end

    derp.valid?.must_equal(false)
    derp.errors[:derp].wont_be_empty
  end

  it 'is additive when block passed twice' do
    Validbot.validate(derp) do
      validates :derp, :presence => true
    end

    Validbot.validate(derp) do
      validates :title, :presence => true
    end

    derp.valid?.must_equal(false)
    derp.errors[:derp].wont_be_empty
    derp.errors[:title].wont_be_empty
  end

  it 'calls lambda syntax validation in a block' do
    Validbot.validate(derp) do
      validate :version, lambda { |awesome|
        if awesome.version.nil? || awesome.version < 10
          awesome.errors.add(:version, 'must be big, like ... really big')
        end
      }
    end

    derp.valid?.must_equal false
    derp.errors[:version].wont_be_empty
    derp.errors[:version].first.must_match /be big/i

    derp.version = 40
    derp.valid?.must_equal true
  end

  it 'calls custom validation methods defined in block' do
    Validbot.validate(derp) do
      validate :version_must_be_big

      def version_must_be_big
        if version.nil? || version < 10
          self.errors.add(:version, 'must be big, like ... really big')
        end
      end
    end

    derp.valid?.must_equal false
    derp.errors[:version].wont_be_empty
    derp.errors[:version].first.must_match /be big/i

    derp.version = 40
    derp.valid?.must_equal true
  end
end

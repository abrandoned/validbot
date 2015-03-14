# Validbot

inspired by http://reefpoints.dockyard.com/ruby/2013/05/09/context-validations.html

attempting to provide a solution to different validations for controller methods depending
on the context and also applying those validations to non-active_record objects

## Installation

Add this line to your application's Gemfile:

    gem 'validbot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validbot

## Usage

Validations are applied to the object that is passed to the validate method, the validations
in the block passed are applied when `valid?` is called on the object.


Basic controller example:

```ruby
  class AwesomeController < ApplicationController

    def create
      @awesome = ::Awesome.new(params)
      validate_create(@awesome)

      if @awesome.valid?
        render :show
      else
        render :error
      end
    end

    def update
      @awesome = ::Awesome.find(params[:id])
      validate_update(@awesome)

      if @awesome.valid?
        render :show
      else
        render :error
      end
    end

  private
    
    def validate_create(awesome_object)
      Validbot.validate(awesome_object) do
        validates :name, :presence => true # name must be present on create
      end
    end

    def validate_update(awesome_object)
      Validbot.validate(awesome_object) do
        validate :has_not_been_updated_recently?

        def has_not_been_updated_recently?
          if self.updated_at && self.updated_at > 15.minutes.ago
            self.errors.add(:updated_at, 'can only update every 15 minutes')
          end
        end
      end
    end
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

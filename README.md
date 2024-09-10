# AzureTTS

AzureTTS is a Ruby gem that provides an interface to Microsoft Azure's Text-to-Speech service. It allows you
to convert text to speech and save it as an audio file or integrate it with Rails' Active Storage.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'azure_tts'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install azure_tts

## Usage


Use the AzureTTS::Client to generate a speech file:
```
# config/initializers/azure_tts.rb
AzureTTS.configure do |config|
  config.region = "your_azure_region"
  config.api_key = "your_azure_api_key"
end
```

```
client = AzureTTS::Client.new
client.speak_file("Hello, world!", "output.wav", {gender: :female, name: 'en-US-JennyNeural', language: 'en-US'})
```


Setup Active Storage in the Model

```
class MyModel < ApplicationRecord
  has_one_attached :audio_file
end
```

```
my_model = MyModel.new
client.speak_to_active_storage("Hello, world!", my_model.audio_file, {gender: :female, name: 'en-US-JennyNeural', language: 'en-US'})
my_model.save
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/graysonchen/azure_tts.

## Reference

- https://github.com/csmpfo/Ruby-Lib-for-Microsoft-Azure-Text-2-Speech/tree/master
- https://github.com/adhearsion/ruby_speech
- https://github.com/cristianbica/azure-tts

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

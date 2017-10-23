# Corpusbuilder::Ruby

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/corpusbuilder/ruby`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'corpusbuilder-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install corpusbuilder-ruby

## Usage
Mount the Gem's routes in the host application:
* mount Corpusbuilder::Ruby::Engine, at: "/corpusbuilder"

Add some information to a configuration file (after application is initialized):
# Note that for setting the api_ul, trailing slashes are not valid ("http://yourwebsite.com/")
* Corpusbuilder::Ruby::Api.config.api_url = "http://yourwebsite.com"
* Corpusbuilder::Ruby::Api.config.api_version = 1
* Corpusbuilder::Ruby::Api.config.app_id = "your app id"
* Corpusbuilder::Ruby::Api.config.token = "your token"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/corpusbuilder-ruby.

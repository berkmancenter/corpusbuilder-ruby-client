require "corpusbuilder/ruby/version"

module Corpusbuilder
  module Ruby
    include ActiveSupport::Configurable
    Corpusbuilder::Ruby.config.base_url = "https://api.some.corpusbuilder.com/"
  end
end

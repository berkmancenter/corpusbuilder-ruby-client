require "corpusbuilder/ruby/version"
require "corpusbuilder/engine.rb"

module Corpusbuilder
  module Ruby
    Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
  end
end

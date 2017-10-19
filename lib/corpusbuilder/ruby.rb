require "corpusbuilder/ruby/version"

module Corpusbuilder
  module Ruby
    #Require the model
    Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
  end
end

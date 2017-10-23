module Corpusbuilder
  module Ruby
    class ApiController < ApplicationController
      def proxy_corpusbuilder
        render :text => "Hello"
      end
    end
  end
end

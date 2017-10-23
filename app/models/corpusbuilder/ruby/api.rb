require "active_support/all"
require "rest-client"

module Corpusbuilder
  module Ruby
    class Api
      include ActiveSupport::Configurable

      def send_image(payload)
        resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/images", payload, headers)
        JSON.parse(resp.body)
      end

      def send_document(payload)
        resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents", payload, headers)
        JSON.parse(resp.body)
      end

      def get_headers
        headers
      end
      private

      def headers
        {
         "Accept" => "application/vnd.corpus-builder-v#{Corpusbuilder::Ruby::Api.config.api_version.to_s}+json",
         "X-App-Id" => Corpusbuilder::Ruby::Api.config.app_id,
         "X-Token" => Corpusbuilder::Ruby::Api.config.token.to_s
        }
      end
    end
  end
end

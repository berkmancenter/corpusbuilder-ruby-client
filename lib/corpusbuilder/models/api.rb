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

      def create_document(payload)
        resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents", payload, headers)
        JSON.parse(resp.body)
      end

      def get_documents
        resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/", headers)
        JSON.parse(resp.body)
      end

      def get_document(document_id)
        resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}", headers)
        JSON.parse(resp.body)
      end

      def get_document_status(document_id)
        resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/status", headers)
        JSON.parse(resp.body)
      end

      def get_document_branches(document_id)
        resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/branches", headers)
        JSON.parse(resp.body)
      end

      def create_document_branch(document_id, editor_id, payload)
        resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/branches",
                               payload,
                               headers.merge!({ "X-Editor-Id" => editor_id })
                              )
        JSON.parse(resp.body)
      end

      def merge_document_branches(document_id, branch, payload)
        resp = RestClient.put(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{branch}/merge",
                              payload,
                              headers)
        JSON.parse(resp.body)
      end

      def get_document_revision_tree(document_id, revision_id, payload={})
        #There is a bug in RestClient which prevents the sending of params AND headers in a GET request, thus the params must be passed with the headers
        # See RestCliet issue 397
        resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{revision_id}/tree", headers.merge!(:params => payload))
        JSON.parse(resp.body)
      end

      def get_document_revision_diff(document_id, revision_id, payload={})
        #There is a bug in RestClient which prevents the sending of params AND headers in a GET request, thus the params must be passed with the headers
        # See RestClient issue 397
        resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{revision_id}/diff", headers.merge!(:params => payload))
        JSON.parse(resp.body)
      end

      def update_document_revision(document_id, revision_id, payload)
        resp = RestClient.put(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{revision_id}/tree", payload, headers)
        JSON.parse(resp.body)
      end

      def create_editor(payload)
        resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/editors", payload, headers)
        JSON.parse(resp.body)
      end

      def get_headers
        headers
      end
      private

      def headers
        {
         "Accept" => "application/vnd.corpus-builder-v#{Corpusbuilder::Ruby::Api.config.api_version.to_s}+json",
         "X-App-ID" => Corpusbuilder::Ruby::Api.config.app_id,
         "X-Token" => Corpusbuilder::Ruby::Api.config.token.to_s
        }
      end
    end
  end
end

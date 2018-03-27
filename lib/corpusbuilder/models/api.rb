require "active_support/all"
require "rest-client"

module Corpusbuilder
  module Ruby
    class Api
      include ActiveSupport::Configurable

      def get(url, _headers = headers)
        resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + url, _headers)
        JSON.parse(resp.body)
      end

      def insert(url, payload, _headers = headers)
        resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + url, payload, _headers)
        JSON.parse(resp.body)
      end

      def update(url, payload, _headers = headers)
        resp = RestClient.put(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{branch}/merge",
                              payload,
                              _headers)
        JSON.parse(resp.body)
      end

      def send_image(payload)
        insert("/api/images", payload)
      end

      def create_document(payload)
        insert("/api/documents", payload)
      end

      def get_documents
        get("/api/documents/")
      end

      def get_document(document_id)
        get("/api/documents/#{document_id}")
      end

      def get_document_status(document_id)
        get("/api/documents/#{document_id}/status")
      end

      def get_document_branches(document_id)
        get("/api/documents/#{document_id}/branches")
      end

      def create_document_branch(document_id, editor_id, payload)
        insert(
          "/api/documents/#{document_id}/branches",
          payload,
          headers.merge!({ "X-Editor-Id" => editor_id })
        )
      end

      def merge_document_branches(document_id, branch, payload)
        update(
          "/api/documents/#{document_id}/#{branch}/merge",
          payload
        )
      end

      def get_document_revision_tree(document_id, revision_id, payload={})
        # There is a bug in RestClient which prevents the sending of params
        # AND headers in a GET request, thus the params must be passed with the headers
        # See RestCliet issue 397
        get(
          "/api/documents/#{document_id}/#{revision_id}/tree",
          headers.merge!(:params => payload)
        )
      end

      def get_document_revision_diff(document_id, revision_id, payload={})
        # There is a bug in RestClient which prevents the sending of params
        # AND headers in a GET request, thus the params must be passed with the headers
        # See RestCliet issue 397
        get(
          "/api/documents/#{document_id}/#{revision_id}/diff",
          headers.merge!(:params => payload)
        )
      end

      def update_document_revision(document_id, revision_id, payload)
        update(
          "/api/documents/#{document_id}/#{revision_id}/tree",
          payload
        )
      end

      def create_editor(payload)
        insert("/api/editors", payload)
      end

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

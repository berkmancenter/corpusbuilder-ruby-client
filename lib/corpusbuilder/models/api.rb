require "active_support/all"
require "rest-client"

module Corpusbuilder
  module Ruby
    class Api
      include ActiveSupport::Configurable

      def send_image(payload)
        unless payload.is_a?(Hash) && (payload[:file].present? || payload['file'].present?)
          Rails.logger.error "Error: You are missing the required param for creating an image, call send_image(file: your_file, name: string (optional))"
          raise "Missing required params"
        end

        begin
          resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/images", payload, headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def create_document(payload)
        unless (payload.is_a?(Hash)) && (payload[:images].present? || payload['images'].present?) &&
               (payload[:metadata].present? || payload['metadata'].present?) &&
               (payload[:editor_email].present? || payload['editor_email'].present?)

          Rails.logger.error "Error: You are missing the required param(s) for creating a document, call create_document({images: [{id: UUID string},{id: UUID string...}], metadata: {title: string, author: string (optional), date: date (optional), editor: string (optional), license: string (optional), notes: string (optional), publisher: string (optional)}, editor_email: string})"
          raise "Missing required params"
        end

        begin
          resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents", payload, headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def get_documents
        begin
          resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/", headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def get_document(document_id)
        unless document_id.is_a? String
          Rails.logger.error "Error: Did you pass get_document a document id as a UUID String?"
          raise "Missing required params"
        end

        begin
          resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}", headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def get_document_status(document_id)
        unless document_id.is_a? String
          Rails.logger.error "Error: Did you pass get_document_status a document id as a UUID String?"
          raise "Missing required params"
        end

        begin
          resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/status", headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def get_document_branches(document_id)
        unless document_id.is_a? String
          Rails.logger.error "Error: Did you pass get_document_branches a document id as a UUID String?"
          raise "Missing required params"
        end

        begin
          resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/branches", headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def create_document_branch(document_id, editor_id, payload)
        unless ((payload.is_a?(Hash)) && payload[:revision].present? || payload['revision'].present?) &&
               (payload[:name].present? || payload['name'].present?)
          Rails.logger.error "Error: You are missing the required param(s) to create a document branch, call create_document_branch(document_id, editor_id, revision: string, name: string)"
          raise "Missing required params"
        end

        begin
          resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/branches",
                                 payload,
                                 headers.merge!({ "X-Editor-Id" => editor_id })
                                )
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def merge_document_branches(document_id, branch, payload)
        unless (payload.is_a?(Hash)) && (payload[:other_branch].present? || payload['other_branch'].present?)
          Rails.logger.error "Error: You are missing the required param to merge a document branch, call merge_document_branch(document_id, branch (string), other_branch: string)"
          raise "Missing required params"
        end

        begin
          resp = RestClient.put(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{branch}/merge",
                                payload,
                                headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def get_document_revision_tree(document_id, revision_id, payload={})
        #There is a bug in RestClient which prevents the sending of params AND headers in a GET request, thus the params must be passed with the headers
        # See RestCliet issue 397
        begin
          resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{revision_id}/tree", headers.merge!(:params => payload))
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def get_document_revision_diff(document_id, revision_id, payload={})
        #There is a bug in RestClient which prevents the sending of params AND headers in a GET request, thus the params must be passed with the headers
        # See RestClient issue 397
        begin
          resp = RestClient.get(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{revision_id}/diff", headers.merge!(:params => payload))
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def update_document_revision(document_id, revision_id, payload)
        #Check for nil instead of present in case an empty array was passed
        unless (payload.is_a?(Hash)) && (payload[:graphemes].nil? || payload['graphemes'].nil?)
          Rails.logger.error "Error: You are missing the required param(s) to add a correction to a given revision, call update_document_revision(document_id, revision_id (string), graphemes: [id: string (optional), value: string (optional), surface_number: int (optional), delete: bool (optional), area (optional): {ulx: string, uly: string, lrx: string, lry: string}])"
          raise "Missing required params"
        end

        begin
          resp = RestClient.put(Corpusbuilder::Ruby::Api.config.api_url + "/api/documents/#{document_id}/#{revision_id}/tree", payload, headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
      end

      def create_editor(payload)
        unless (payload.is_a?(Hash)) && (payload[:email].nil? || payload['email'].nil?)
          Rails.logger.error "Error: You are missing the required param to create an editor, call create_editor(email: string, first_name: string (optional), last_name: string (optional))"
          raise "Missing required params"
        end

        begin
          resp = RestClient.post(Corpusbuilder::Ruby::Api.config.api_url + "/api/editors", payload, headers)
          JSON.parse(resp.body)
        rescue
          Rails.logger.info $!.message
          raise $!
        end
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

class ProxyController < ApplicationController
  include ActionController::Live

  def speak_with_cb
    response.headers['Content-Type'] = 'application/json; charset=utf-8'

    url = Corpusbuilder::Ruby::Api.config.api_url + '/api' + request.original_url.split("api")[1]
    payload = params.has_key?("_json") ? JSON.parse(params["_json"]) : params

    payload.delete "controller"
    payload.delete "action"
    payload.delete "path"

    begin
      handle_response = -> (res) {
        response.status = res.code

        res.read_body do |segment|
          response.stream.write segment
        end
      }

      payload = payload.permit!.to_hash if payload.respond_to?(:permit!)

      RestClient::Request.execute(
        method: request.method.downcase.to_sym,
        url: url,
        payload: payload,
        headers: proxy_headers,
        timeout: 180,
        block_response: handle_response
      )
    rescue => e
      Rails.logger.error "#{e.message} - #{e.class.to_s} - #{e.backtrace.join("\n")}"
      result = ""
      resulting_status = 500

      if e.respond_to?(:response)
        Rails.logger.error "#{e.message} - #{e.class.to_s}"
        result = e.response.body
        resulting_status = e.response.code
      end

      render json: result, status: resulting_status
    ensure
      response.stream.close
    end
  end

  private

  def proxy_headers
    editor_id = Corpusbuilder::Ruby::Api.config.editor_id.call(self)
    if editor_id.nil?
      Corpusbuilder::Ruby::Api.new.headers
    else
      Corpusbuilder::Ruby::Api.new.headers.merge("X-Editor-Id" => editor_id)
    end
  end

end

class ProxyController < ApplicationController

  def speak_with_cb
    result = {}
    resulting_status = 200

    url = Corpusbuilder::Ruby::Api.config.api_url + '/api' + request.original_url.split("api")[1]
    payload = params.has_key?("_json") ? JSON.parse(params["_json"]) : params


    payload.delete "controller"
    payload.delete "action"
    payload.delete "path"

    begin
      resp = RestClient::Request.execute(
        method: env["REQUEST_METHOD"].downcase,
        url: url,
        payload: payload,
        headers: proxy_headers
      )
      result = resp.body
      resulting_status = resp.code
    rescue => e
      if e.respond_to?(:response)
        Rails.logger.error "#{e.message} - #{e.class.to_s}"
        result = e.response.body
        resulting_status = e.response.code
      else
        Rails.logger.error "An error ocurred"
        resulting_status = 500
      end
    end

    render json: result, status: resulting_status
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

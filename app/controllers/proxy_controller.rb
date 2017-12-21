class ProxyController < ApplicationController

  def speak_with_cb
    result = {}
    resulting_status = 200

    url = Corpusbuilder::Ruby::Api.config.api_url + '/api' + request.original_url.split("api")[1]
    payload = params.has_key?("_json") ? JSON.parse(params["_json"]) : params

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
      Rails.logger.error "#{e.message} - #{e.class.to_s}"
      if e.respond_to?(:response)
        result = e.response.body
        resulting_status = e.response.code
      else
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

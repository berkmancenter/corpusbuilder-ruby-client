class ProxyController < ApplicationController

  def speak_with_cb
    http_verb = env["REQUEST_METHOD"].downcase
    headers = Corpusbuilder::Ruby::Api.new.get_headers
    url = Corpusbuilder::Ruby::Api.config.api_url + '/api' + request.original_url.split("api")[1]
    payload = params.has_key?("_json") ? JSON.parse(params["_json"]) : params
    render json: RestClient::Request.execute(method: http_verb.to_sym, url: url, payload: payload, headers: headers).body
  end
end

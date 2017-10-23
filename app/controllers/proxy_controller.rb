class ProxyController < ApplicationController

  def speak_with_cb
    http_verb = env["REQUEST_METHOD"].downcase
    headers = Corpusbuilder::Ruby::Api.new.get_headers
    url = Corpusbuilder::Ruby::Api.config.api_url + '/api' + request.original_url.split("corpusbuilder")[1]
    RestClient::Request.execute(method: http_verb.to_sym, url: url, payload: params, headers: headers)
  end
end

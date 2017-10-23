class ProxyController < ApplicationController

  def speak_with_cb
    render :text => params
  end

  def documents
    corpusbuilder = Corpusbuilder::Ruby::Api.new
    corpusbuilder.send_document(params[:document])
  end

  def images
    corpusbuilder = Corpusbuilder::Ruby::Api.new
    corpusbuilder.send_images(params)
  end

end

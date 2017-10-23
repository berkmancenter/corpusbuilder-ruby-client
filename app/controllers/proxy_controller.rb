class ProxyController < ApplicationController
  def speak_with_cb
    render :text => params
  end
end

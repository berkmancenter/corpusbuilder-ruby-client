Rails.application.routes.draw do
  match '/api/*path', :to => 'proxy#speak_with_cb', via: [:all]
end

Rails.application.routes.draw do
  match '/corpusbuilder/*path', :to => 'proxy#speak_with_cb', via: [:all]
end

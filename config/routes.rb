Rails.application.routes.draw do
  match 'corpusbuilder/*', :to => 'api#proxy_corpusbuilder', via: [:all]
end

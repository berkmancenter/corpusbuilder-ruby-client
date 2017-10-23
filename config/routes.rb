Rails.application.routes.draw do
  match ':corpusbuilder((/:action(/:id(.:format))))', :to => 'api#proxy', via: [:all]
end

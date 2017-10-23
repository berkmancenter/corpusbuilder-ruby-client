Rails.application.routes.draw do
  match ':corpusbuilder((/:action(/:id(.:format))))', :to => 'proxy#speak_with_cb', via: [:all]
end

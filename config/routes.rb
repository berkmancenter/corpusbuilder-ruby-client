Rails.application.routes.draw do
  scope :corpusbuilder, module: 'api', constraints: { format: 'json' } do
    resources :documents, :images
  end
end

Rails.application.routes.draw do
  root 'search#index'
  get '/pac14850807.html' => redirect('/pac14850807.html')
  post 'author-data', to: 'authors#index'
  resources :products
end

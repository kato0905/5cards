Rails.application.routes.draw do
  get 'rooms/show'
  get 'rooms/index'
  post 'rooms/index' => 'rooms#show'
  post '/index' => "rooms#show"
  get 'rooms/reset'
  #post 'rooms/show' => 'rooms#reset'
  #post 'rooms/' => 'rooms#reset'
  #post '/' => 'rooms#reset'
  root to: 'rooms#index'
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

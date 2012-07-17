CardGames::Application.routes.draw do
  resources :games

  resources :played_tricks

  resources :tricks

  resources :rounds

  resources :teams

  resources :cards

  resources :users

  root :to => 'rooms#index'

  
	resources :sessions
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'
	
end

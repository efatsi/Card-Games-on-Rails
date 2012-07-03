CardGames::Application.routes.draw do
  resources :rooms

  resources :teams

  resources :decks

  resources :cards

  resources :users

  root :to => 'rooms#index'

  
	resources :sessions
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'
	
end

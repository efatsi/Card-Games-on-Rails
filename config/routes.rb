CardGames::Application.routes.draw do
  resources :games

  resources :played_tricks

  resources :tricks

  resources :rounds

  resources :rooms do
    post :fill, :on => :member
    post :deal_cards, :on => :member
  end
  

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

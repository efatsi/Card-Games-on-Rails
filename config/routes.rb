CardGames::Application.routes.draw do
  
  resources :games do
    post :fill, :on => :member
    post :new_round, :on => :member
    post :play_trick, :on => :member
    post :play_rest_of_tricks, :on => :member
  end
  
  resources :users

  root :to => 'games#index'

  
	resources :sessions
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'
	
end

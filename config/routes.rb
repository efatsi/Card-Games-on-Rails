CardGames::Application.routes.draw do
  
  resources :games do
    post :fill, :on => :member
    post :deal_cards, :on => :member
    post :play_trick, :on => :member
    post :update_scores, :on => :member
  end
  
  resources :users

  root :to => 'games#index'

  
	resources :sessions
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'
	
end

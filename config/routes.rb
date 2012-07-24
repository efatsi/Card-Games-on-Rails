CardGames::Application.routes.draw do
  
  resources :games do
    post :fill, :on => :member
    
    post 'new_round' => 'rounds#create'
    # post :new_round, :on => :rounds
    
    post 'new_trick' => 'tricks#create'
    post :new_trick, :on => :member
    post :play_all_but_one_trick, :on => :member
    post :play_one_card, :on => :member
    post :pass_cards, :on => :member
    post :choose_card_to_pass, :on => :member
    post :fill_passing_sets, :on => :member
  end
  
  
  
  resources :users

  root :to => 'games#index'

  
	resources :sessions
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'
	
end

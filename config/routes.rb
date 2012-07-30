CardGames::Application.routes.draw do
  
  resources :games do
    get 'show', :on => :member
    post 'fill' => 'fill_games#fill'
    post 'new_round' => 'rounds#create'
    post 'new_trick' => 'tricks#create'
    post 'play_one_card' => 'played_cards#create'
    post 'pass_cards' => 'card_passings#create'
    post 'choose_card_to_pass' => 'card_passings#choose_card_to_pass'
    post 'unchoose_card_to_pass' => 'card_passings#unchoose_card_to_pass'
    post 'passing_set_ready' => 'card_passings#passing_set_ready'
  end
    
  resources :users
  
	resources :sessions
	
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'

  root :to => 'games#index'
	
end

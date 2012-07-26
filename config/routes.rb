CardGames::Application.routes.draw do
  
  resources :games do
    get 'get_game_info', :on => :member
    post 'fill' => 'fill_games#fill'
    post 'new_round' => 'rounds#create'
    post 'new_trick' => 'tricks#create'
    post 'play_all_but_one_trick' => 'played_cards#play_all_but_one_trick'
    post 'play_one_card' => 'played_cards#create'
    post 'pass_cards' => 'card_passings#pass_cards'
    post 'choose_card_to_pass' => 'card_passings#choose_card_to_pass'
    post 'fill_passing_sets' => 'card_passings#fill_passing_sets'
  end
    
  resources :users
  
	resources :sessions
	
	match 'signup' => 'users#new'
	match 'logout' => 'sessions#destroy'
	match 'login' => 'sessions#new'

  root :to => 'games#index'
	
end

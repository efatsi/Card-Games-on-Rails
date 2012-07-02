CardGames::Application.routes.draw do
  resources :rooms

  resources :teams

  resources :decks

  resources :cards

  resources :users

  root :to => rooms_url

end

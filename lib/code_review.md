## GamesController
* Make Game#add_player instead of Player.create in join_game -- consider User#join_game(game)
* Remove get_game_info and merge into show with `respond_to`

## ApplicationController
* Consider creating a `current_game` helper method
* Redefine `current_player` as the intersection between the current_user and current_game
* Remove `assign_variables` and use those methods in the view (off of `current_game` / `current_player`)

## RoundsController
- Remove `sleep` calls -- this should be a client concern (setTimeout in JS)
- Create Game#create_round method and add lifecycle hooks

## PlayedCardsController
- In create, add Game#play_card(card) method

## CardPassingsController
* Remove choose_card_to_pass / unchoose_card_to_pass -- client-side concern
- Move `pass_cards` into `create` action

## TricksController
* Consider creating a `current_round` helper method
- Create a Round#create_trick method and refactor Trick.create into it

## FillGamesController
- Move `fill` logic into Game#fill
- Consider not requiring Player#user and define is_human? to be whether or not the player has an associated user.  Delegate username to User or generate cp<seat_position>
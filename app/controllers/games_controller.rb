class GamesController < ApplicationController


  before_filter :assign_game, :except => [:index, :new, :create]
  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show

  def index
    @games = Game.all
  end

  def show
    join_game
    @hand = current_user.hand
    @round_over = @game.round_over
    @trick_over = @game.trick_over
    @my_turn = false
    
    round = @game.last_round
    if round
      trick = round.last_trick 
      if trick
        @lead_suit = trick.lead_suit
        if current_user.current_player == trick.next_player && !@trick_over
          @my_turn = true
        end
      end
    end
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])
    if @game.save
      redirect_to @game
    else
      render action: "new"
    end
  end

  def destroy
    @game.destroy
    redirect_to games_url
  end

  # UNRESTFUL ACTIONS

  def fill
    # raise @game.players.length.inspect
    (4 - @game.players.length).times do |i|
      # raise "here".inspect
      u = User.create(:username => "cp#{User.all.length}")
      Player.create(:user_id => u.id, :game_id => @game.id, :seat => @game.reload.next_seat)
    end
    redirect_to @game
  end

  def new_round
    round = Round.create(:game_id => @game.id, :dealer_id => @game.get_new_dealer.id, :position => @game.next_round_position)
    round.deal_cards
    round.create_player_rounds
    redirect_to @game
  end

  def play_rest_of_tricks    
    round = @game.last_round
    (12 - round.tricks_played).times do
      if round.tricks_played != 13
        trick = Trick.create(:round_id => round.id, :leader_id => round.get_new_leader.id, :position => round.next_trick_position)
        trick.play_trick
      end  
    end  
    round.calculate_round_scores
    round.update_total_scores if round.tricks_played == 13
    redirect_to @game
  end

  def new_trick
    round = @game.last_round
    trick = Trick.create(:round_id => round.id, :leader_id => round.get_new_leader.id, :position => round.next_trick_position)
    redirect_to @game
  end
  
  def play_one_card
    round = @game.last_round
    trick = round.last_trick
    player = trick.next_player
    # raise params[:card].inspect
    player_choice = PlayerCard.find(params[:card].to_i) if params[:card]
    trick.play_card_from(player, player_choice)
    if @game.trick_over
      round.calculate_round_scores
      if @game.round_over
        round.update_total_scores
        @game.check_for_and_set_winner
      end
    end
    redirect_to @game
  end
  
  


  private
  def assign_game    
    @game = Game.find(params[:id])
  end

  def join_game
    unless @game.already_has(current_user) or @game.is_full?
      Player.create(:user_id => current_user.id, :game_id => @game.id, :seat => @game.next_seat)
    end
  end


end

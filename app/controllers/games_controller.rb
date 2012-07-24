class GamesController < ApplicationController


  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show
  before_filter :assign_variables, :except => [:index, :new, :create]

  def index
    @games = Game.all
  end

  def show
    join_game
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
    (4 - @game.players.length).times do |i|
      u = User.create(:username => "cp#{User.all.length}")
      Player.create(:user_id => u.id, :game_id => @game.id, :seat => @game.reload.next_seat)
    end
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'game_page'
        else
          redirect_to @game
        end
      }
    end
  end

  def new_round
    round = Round.create(:game_id => @game.id, :dealer_id => @game.get_new_dealer.id, :position => @game.next_round_position)
    round.deal_cards
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'game_page'
        else
          redirect_to @game
        end
      }
    end
    
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
    
    
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  
  def play_one_card
    round = @game.last_round
    trick = round.last_trick
    player = trick.next_player
    player_choice = PlayerCard.find(params[:card].to_i) if params[:card]
    trick.play_card_from(player, player_choice)
    
    if trick.reload.is_over?
      round.calculate_round_scores
      if round.is_over?
        round.update_total_scores
        @game.check_for_and_set_winner
      end
    end
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  
  
  def pass_cards
    round = @game.last_round
    round.pass_cards
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  
  def choose_card_to_pass
    player_choice = PlayerCard.find(params[:card].to_i)
    current_player.card_passing_set.player_cards << player_choice
  
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  
  def fill_passing_sets
    round = @game.last_round
    round.fill_passing_sets
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  

  private
  def assign_variables    
    @game = Game.find(params[:id])

    #my_hand
    @hand = current_player.try(:hand)
    @lead_suit = @game.get_lead_suit
    @my_turn = @game.is_current_player_next?(current_player)
    
    #game_progress
    @last_trick = @game.last_trick
    @played_cards = @game.played_cards
    @trick_over = @game.trick_over?
  end

  def join_game
    unless @game.already_has(current_user) or @game.is_full?
      Player.create(:user_id => current_user.id, :game_id => @game.id, :seat => @game.next_seat)
    end
  end
  

end

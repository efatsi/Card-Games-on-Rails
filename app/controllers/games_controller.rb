class GamesController < ApplicationController


  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show
  before_filter :assign_game, :only => [:show, :fill, :play_all_but_one_trick]

  def index
    @games = Game.all
  end

  def show
    join_game
    assign_variables
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
          render :partial => 'shared/game_page'
        else
          redirect_to @game
        end
      }
    end
  end

  def play_all_but_one_trick  
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

  private
  def join_game
    unless @game.already_has(current_user) or @game.is_full?
      Player.create(:user_id => current_user.id, :game_id => @game.id, :seat => @game.next_seat)
    end
  end
  

end

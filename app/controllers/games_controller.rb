class GamesController < ApplicationController


  before_filter :store_location, :only => [:index, :show]
  before_filter :require_user, :only => :show
  before_filter :assign_game, :only => [:show, :destroy]

  def index
    @games = Game.all
  end

  def show
    # api_key = "17052081"
    # api_secret = "0d219ab9c3e5a7bf92fec80ba458f0e7ba6a3a2d"
    # @opentok = OpenTok::OpenTokSDK.new api_key, api_secret if @opentok.nil?
    # @token = @opentok.generate_token(:session_id => @game.session_id)

    @game.add_player_from_user(current_user)
    respond_to do |format|
      format.html
      format.json do
        render :json => {
          :computerShouldPlay => @game.computer_should_play?,
          :shouldStartNewRound => @game.is_ready_for_a_new_round?,
          :shouldStartNewTrick => @game.is_ready_for_a_new_trick?,
          :shouldPassCards => @game.ready_to_pass?,
          :isStartingFirstRound => @game.rounds.empty?,
          :isStartingFirstTrick => current_round.try(:tricks).try(:empty?),
          :shouldReloadWaitAutoplay => @game.should_reload?(current_player),
          :shouldReloadAndJustWait => @game.should_reload_and_wait?(current_player),
          :shouldReloadPreviousTrick => @game.should_reload_previous_trick?
        }
      end
    end
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])

    # api_key = "17052081"
    # api_secret = "0d219ab9c3e5a7bf92fec80ba458f0e7ba6a3a2d"
    # @opentok = OpenTok::OpenTokSDK.new api_key, api_secret
    #
    # session = @opentok.create_session request.remote_addr
    # @game.update_attributes(:session_id => session.session_id)


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

  def reload
    reload_partial
  end

end

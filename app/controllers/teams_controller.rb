class TeamsController < ApplicationController

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    @team.save
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
  end
  
end

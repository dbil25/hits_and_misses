class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  authorize_resource

  def index
  end

  def current
    redirect_to user_path(current_user)
  end

  def show
    @teams = @user.teams
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username)
  end
end

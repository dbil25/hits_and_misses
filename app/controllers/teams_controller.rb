class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]
  authorize_resource

  # GET /teams/1 or /teams/1.json
  def show
    members = @team.members.preload(:roles)
    @pending_members = members.select{ |m| m.status == "pending" }
    @admins_members = members.select{ |m| m.has_cached_role? :admin }
    @members = members - @pending_members - @admins_members

    @meetings = Meeting.order(date: :desc)
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)
    @team.tenant_name = @team.name
    @member = @team.members.new(user: current_user)

    respond_to do |format|
      if @team.save && @member.save
        Apartment::Tenant.switch(@team.tenant_name) { @member.grant :admin }
        format.html { redirect_to user_path(current_user), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def request_invite
    @team = Team.find_by(name: params.require(:team)[:name])
    if @team
      @member = @team.members.find_or_initialize_by(user: current_user)
      @member.update(status: :pending)
    end
    redirect_to user_path(current_user), notice: "requested a join if that team exists"
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to team_url(@team), notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find_by(tenant_name: Apartment::Tenant.current)
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name)
    end
end

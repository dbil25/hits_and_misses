class ReactionsController < ApplicationController
  before_action :set_reaction, only: %i[ show edit update destroy ]

  # GET /reactions
  def index
    @reactions = Reaction.all
  end

  # GET /reactions/1
  def show
  end

  # GET /reactions/new
  def new
    @reaction = Reaction.new
  end

  # GET /reactions/1/edit
  def edit
  end

  # POST /reactions
  def create
    @reaction = Reaction.new(reaction_params.merge(author: current_member, comment_id: params[:comment_id]))

    @reaction.save
    Turbo::StreamsChannel.broadcast_stream_to(dom_id(@reaction.comment.meeting) + Apartment::Tenant.current, content: render(template: "reactions/create", format: :turbo_stream))
  end

  # PATCH/PUT /reactions/1
  def update
    if @reaction.update(reaction_params)
      redirect_to @reaction, notice: "Reaction was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reactions/1
  def destroy
    @reaction.destroy
    redirect_to reactions_url, notice: "Reaction was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reaction
      @reaction = Reaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reaction_params
      params.require(:reaction).permit(:content)
    end
end

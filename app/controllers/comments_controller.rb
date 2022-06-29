class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    puts params
    @comment = Comment.new(comment_params.merge(author: current_member))
    @comment.save

    Turbo::StreamsChannel.broadcast_stream_to(dom_id(@comment.meeting) + Apartment::Tenant.current, content: render(template: "comments/create", format: :turbo_stream))
    head 200
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to comments_url, notice: "Comment was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    if params[:comments_miss]
      params.require(:comments_miss).permit(:type, :meeting_id, :body)
    else
      params.require(:comments_hit).permit(:type, :meeting_id, :body)
    end
  end
end

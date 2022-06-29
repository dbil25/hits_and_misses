class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params.merge(author: current_member))
    if @comment.save
      Turbo::StreamsChannel.broadcast_stream_to(dom_id(@comment.meeting) + Apartment::Tenant.current, content: render_to_string(template: "comments/create", format: :turbo_stream))
      if @comment.body.to_plain_text == "never gonna give you up"
        Turbo::StreamsChannel.broadcast_stream_to(dom_id(@comment.meeting) + Apartment::Tenant.current, content: render_to_string(template: "comments/rick_roll", format: :turbo_stream))
      end
    end
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

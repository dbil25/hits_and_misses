class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[ show edit update destroy start ]

  # GET /meetings
  def index
    @meetings = Meeting.all
  end

  # GET /meetings/1
  def show
    @hits = Comments::Hit.where(meeting: @meeting)
    @misses = Comments::Miss.where(meeting: @meeting)
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new(date: Date.today)
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  def create
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      redirect_to @meeting, notice: "Meeting was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def start
    duration = params.require(:meeting)[:duration]
    @meeting.update(started_at: Time.now, duration_seconds: duration.to_i * 60)
    Turbo::StreamsChannel.broadcast_stream_to(dom_id(@meeting) + Apartment::Tenant.current, content: render(template: "meetings/start_meeting", format: :turbo_stream))
  end

  # PATCH/PUT /meetings/1
  def update
    if @meeting.update(meeting_params)
      redirect_to @meeting, notice: "Meeting was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /meetings/1
  def destroy
    @meeting.destroy
    redirect_to meetings_url, notice: "Meeting was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id] || params[:meeting_id] )
    end

    # Only allow a list of trusted parameters through.
    def meeting_params
      params.require(:meeting).permit(:date, :name)
    end
end

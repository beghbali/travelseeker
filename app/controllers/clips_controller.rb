class ClipsController < ApplicationController
  layout 'clips'
  before_action :set_clip, only: [:show, :edit, :update, :destroy]

  # GET /clips
  # GET /clips.json
  def index
    tags = Array.wrap params.permit(:tags)[:tags]
    @clips = @allclips = Clip.where(session_id: session.id)
    @clips = @allclips.tagged_with(tags, any: true) if tags.any?
    @available_tags = Clip.available_tags_for(session.id)
  end

  # GET /clips/1
  # GET /clips/1.json
  def show
  end

  # GET /clips/new
  def new
    @clip = Clip.new
  end

  # GET /clips/1/edit
  def edit
  end

  # POST /clips
  # POST /clips.json
  def create
    @clip = Clip.new(clip_params)
    @clip.session_id = session.id
    @clip.near = Clip.last_clip_location_for_session(session.id)
    session[:seen_hero] = true
    session[:seen_video] = true
    session[:seen_tips] = true

    respond_to do |format|
      if @clip.save
        last_clip(@clip)
        format.html { redirect_to clips_path, notice: 'Clip was successfully created.' }
        format.json { render action: 'index', status: :created, location: @clip }
      else
        format.html { render action: 'new' }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clips/1
  # PATCH/PUT /clips/1.json
  def update
    respond_to do |format|
      if @clip.update(clip_params)
        last_clip(@clip)
        format.html { redirect_to @clip.ancestor, notice: 'Clip was successfully updated.', change: "list"}
        format.json { respond_with_bip(@clip) }
      else
        format.html { puts @clip.errors.full_messages; head :unprocessable_entity }
        format.json { respond_with_bip(@clip) }
      end
    end
  end

  def copy
    clip = Clip.find(params[:id])
    session[:copy_clip_id] = clip.id
    trip_id = copy_params[:trip_id]

    unless copy_params[:new_trip].blank?
      trip_id = Trip.create(location: copy_params[:new_trip], session_id: session.id, user_id: current_user.id).id
    end
    copy = clip.copy_to(trip_id.to_i)
    last_clip(copy)

    respond_to do |format|
      format.json { respond_with_bip(clip, param: :clip) }
    end
  end

  # DELETE /clips/1
  # DELETE /clips/1.json
  def destroy
    @clip.destroy
    respond_to do |format|
      format.html { redirect_to trip_path(@clip.trip.parent), change: 'list' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clip
      @clip = Clip.find(params[:id])
    end

    def copy_params
      params.require(:clip).permit(:trip_id, :new_trip)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clip_params
      params.require(:clip).permit(:name, :address, :latitude, :longitude, :uri, :remote_image_url, :image, :scheduled_at, :date_list, :day_list, :type_list, comment_attributes: [:comment])
    end

    def last_clip(clip)
      session[clip.ancestor.id] = clip.id
    end
end

class ClipsController < ApplicationController
  layout 'clips'
  before_action :set_clip, only: [:show, :edit, :update, :destroy]

  # GET /clips
  # GET /clips.json
  def index
    @clips = Clip.where(session_id: session.id)
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

    respond_to do |format|
      if @clip.save
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
        format.html { redirect_to @clip, notice: 'Clip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clips/1
  # DELETE /clips/1.json
  def destroy
    @clip.destroy
    respond_to do |format|
      format.html { redirect_to clips_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clip
      @clip = Clip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clip_params
      params[:clip].permit(:uri)
    end

end

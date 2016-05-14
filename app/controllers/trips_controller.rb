class TripsController < ApplicationController
  layout 'trips'
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :trip_details]
  before_action :authorize_trip_access, only: [:show, :edit, :update, :destroy, :trip_details]
  before_action :set_show_variables, only: [:show, :update]
  before_action :set_new_variables, only: [:new, :create]

  # GET /trips
  # GET /trips.json
  def index
    @trips = current_user.trips
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @select_all = true
    redirect_to trip_day_path(@trip, day: 1) unless @readonly || @day.present? || performed?
  end

  def trip_details
    render partial: 'trip', locals: {trip: @trip}, layout: false
  end

  # GET /trips/new
  def new
    @trip = Trip.new
    @location = Location.new(latitude: 0, longitude: 0)
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(trip_params)
    @trip.session_id = session.id
    @trip.user_id = current_user.id

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip.parent || @trip, notice: 'Trip was successfully created.', change: 'list' }
        format.json { render action: 'show', status: :created, location: @trip, day: 1 }
      else
        format.html { render action: 'new' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip.parent || @trip, notice: 'Trip was successfully updated.', change: "list" }
        format.json { head :no_content }
      else
        format.html { redirect_to @trip.parent || @trip }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to @trip.parent || trips_url, change: 'trip' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      id = params[:id] || params[:trip_id]
      @readonly = false
      if id =~ /[[:alnum:]]{10}/
        @trip = Trip.find_by_slug(id)
        @trip.readonly!
        @readonly = true
      else
        @trip = Trip.find(id)
      end
    end

    def set_show_variables
      @location = @trip.clips.last.try(:location) || @trip.location
      @day = params[:day].try(:to_i)
      @selected_trip = @trip.all_clips.last.try(:trip)
    end

    def set_new_variables
      sample_trips = Rails.env.production? ? [1028, 1566, 1568] : [120, 110, 106]
      @trips = signed_in? ? current_user.trips : Trip.where(id: sample_trips)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:location, :latitude, :longitude, :start_date, :end_date, :days, :notes, clips_attributes: [:uri, :day_list, :date_list, :type_list, :day, :date])
    end

    def authorize_trip_access
      # if !Rails.env.development?
      #   return redirect_to(new_trip_path) if @trip.user != current_user
      # end
    end
end

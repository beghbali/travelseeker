class TripsController < ApplicationController
  layout 'trips'
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :trip_details]

  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @location = @trip.location
    @day = params[:day].try(:to_i)
    redirect_to trip_day_path(@trip, day: 1) unless @day.present?
  end

  def trip_details
    render partial: 'trip', locals: {trip: @trip}
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

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
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
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id] || params[:trip_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:location, :latitude, :longitude, :start_date, :end_date, :days, clips_attributes: [:uri, :day_list, :date_list, :type_list, :day, :date])
    end
end

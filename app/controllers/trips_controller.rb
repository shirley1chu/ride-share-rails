class TripsController < ApplicationController
  def index
    if params[:passenger_id]
      passenger = Passenger.find_by(id: params[:passenger_id])
      if passenger
        @trips = passenger.trips
      else
        head :not_found
        return
      end
    else
      @trips = Trip.all
    end
  end

  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    unless @trip
      redirect_to trips_path
    end
  end

  def create
    if params[:passenger_id]
        passenger = Passenger.find_by(id: params[:passenger_id])
        if passenger
        @trip = Trip.new(passenger: passenger, driver: )
    else 
        head :not_found
        

    if @trip.save
      redirect_to trips_path
    else
      render :new, status: :bad_request
    end
  end

  def edit
    trip_id = params[:id]
    @trip = trip.find_by(id: trip_id)

    unless @trip
      redirect_to trips_path
    end
  end

  def update
    @trip = trip.find_by(id: params[:id])

    unless @trip
      head :not_found
      return
    end

    unless @trip.update(trip_params)
      render :edit, status: :bad_request
      return
    else
      redirect_to trip_path(@trip)
    end
  end

  def destroy
    trip_id = params[:id]

    trip = trip.find_by(id: trip_id)

    unless trip
      head :not_found
      return
    end

    trip.destroy

    redirect_to trips_path
  end

  private
end

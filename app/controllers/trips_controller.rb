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
        # randomly assign a driver, because we're assuming all drivers in the db are available
        # because it seems like adding an availiability column and validing available/unavailiable when the
        # trip ends seems beyond the scope of this project?
        @trip = Trip.create(passenger: passenger, driver: Driver.all.sample)
      else
        head :not_found
      end
      redirect_to passenger_trips_path(passenger)
    end
  end

  def edit
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)

    unless @trip
      redirect_to trips_path
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])

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

    trip = Trip.find_by(id: trip_id)

    unless trip
      head :not_found
      return
    end

    trip.destroy

    redirect_to trips_path
  end

  private

  def trip_params
    return params.require(:trip).permit(:rating)
  end
end

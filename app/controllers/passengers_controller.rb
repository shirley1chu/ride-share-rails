class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def show
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)
    unless @passenger
      redirect_to passengers_path
    end
  end

  def new
    @passenger = Passenger.new
  end

  def create
    puts "successfully created"
    @passenger = Passenger.new(passenger_params)

    if @passenger.save
      redirect_to passengers_path
    else
      render :new, status: :bad_request
    end
  end

  def edit
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)

    unless @passenger
      redirect_to passengers_path
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])

    unless @passenger
      head :not_found
      return
    end

    unless @passenger.update(passenger_params)
      render :edit, status: :bad_request
      return
    else
      redirect_to passenger_path(@passenger)
    end
  end

  def destroy
    passenger_id = params[:id]

    passenger = Passenger.find_by(id: passenger_id)

    unless passenger
      head :not_found
      return
    end

    passenger.destroy

    redirect_to passengers_path
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end

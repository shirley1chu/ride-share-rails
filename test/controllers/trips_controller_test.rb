require "test_helper"

describe TripsController do
  before do
    @driver = Driver.create!(name: "test driver", vin: 1234567890123456)
    @passenger = Passenger.create!(name: "mickey mouse", phone_num: "555-555-5555")
    @trip = Trip.create!(driver: @driver, passenger: @passenger)
  end
  describe "index" do
    it "renders without crashing" do
      # Arrange

      # Act
      get trips_path

      # Assert
      must_respond_with :ok
    end

    it "renders even if there are zero trips" do
      # Arrange
      @trip.destroy

      # Act
      get trips_path

      # Assert
      must_respond_with :ok
    end
  end

  describe "show" do
    it "redirects to trips path if the trip doesn't exist" do
      trip_id = 12345

      get trip_path(trip_id)
      must_respond_with :redirect
      must_redirect_to trips_path
    end

    it "works for a trip that exists" do
      get trip_path(@trip.id)

      must_respond_with :ok
    end
  end

  describe "new" do
    it "returns status code 200" do
      get new_trip_path
      must_respond_with :ok
    end
  end

  describe "create" do
    it "creates a new trip" do
      # Arrange
      trip_data = {
        trip: {
          passenger: @passenger,
        },
      }

      # Act
      expect {
        post passenger_trips_path(@passenger), params: trip_data
      }.must_change "Trip.count", +1

      # Assert
      must_respond_with :redirect
      must_redirect_to passenger_trips_path(@passenger)

      trip = Trip.last
      expect(trip.passenger).must_equal trip_data[:trip][:passenger]
      expect(trip.driver).must_be_instance_of Driver

      # trip_data[:trip].keys.each do |key|
      #   expect(trip.attributes[key]).must_equal trip_data[:trip][key]
      # end
    end

    it "sends back bad_request if no trip data is sent" do
      trip_data = {
        trip: {
          passenger: nil,
        },
      }
      expect(Trip.create(trip_data[:trip]).valid?).must_equal false

      # Act
      expect {
        post trips_path, params: trip_data
      }.wont_change "Trip.count"

      # # Assert
      # must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with OK for a real trip" do
      get edit_trip_path(@trip)
      must_respond_with :ok
    end

    it "responds with redirect for a fake trip" do
      trip_id = trip.last.id + 1
      get edit_trip_path(trip_id)
      must_respond_with :redirect
      must_redirect_to trips_path
    end
  end

  describe "update" do
    let(:trip_data) {
      {
        trip: {
          name: "updated name",
        },
      }
    }
    it "changes the data on the model" do
      # Assumptions
      @trip.assign_attributes(trip_data[:trip])
      expect(@trip).must_be :valid?
      @trip.reload

      # Act
      patch trip_path(@trip), params: trip_data

      # Assert
      must_respond_with :redirect
      must_redirect_to trip_path(@trip)

      @trip.reload
      expect(@trip.name).must_equal(trip_data[:trip][:name])
    end

    it "responds with NOT FOUND for a fake trip" do
      trip_id = trip.last.id + 1
      patch trip_path(trip_id), params: trip_data
      must_respond_with :not_found
    end

    it "responds with BAD REQUEST for bad data" do
      # Arrange
      trip_data[:trip][:name] = ""

      # Assumptions
      @trip.assign_attributes(trip_data[:trip])
      expect(@trip).wont_be :valid?
      @trip.reload

      # Act
      patch trip_path(@trip), params: trip_data

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "removes the trip from the database" do
      # Act
      expect {
        delete trip_path(@trip)
      }.must_change "trip.count", -1

      # Assert
      must_respond_with :redirect
      must_redirect_to trips_path

      after_trip = trip.find_by(id: @trip.id)
      expect(after_trip).must_be_nil
    end

    it "returns a 404 if the trip does not exist" do
      # Arrange
      trip_id = 123456

      # Assumptions
      expect(trip.find_by(id: trip_id)).must_be_nil

      # Act
      expect {
        delete trip_path(trip_id)
      }.wont_change "trip.count"

      # Assert
      must_respond_with :not_found
    end
  end
end

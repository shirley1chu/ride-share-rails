require "test_helper"

# validation for name and phone number

describe PassengersController do
  before do
    # @trip = Trip.create!(name: "test trip")
    @passenger = Passenger.create!(name: "mickey mouse", phone_num: "555-555-5555")
  end
  describe "index" do
    it "renders without crashing" do
      # Arrange

      # Act
      get passengers_path

      # Assert
      must_respond_with :ok
    end

    it "renders even if there are zero passengers" do
      # Arrange
      @passenger.destroy

      # Act
      get passengers_path

      # Assert
      must_respond_with :ok
    end
  end

  describe "show" do
    it "redirects to passengers path if the passenger doesn't exist" do
      passenger_id = 12345

      get passenger_path(passenger_id)
      must_respond_with :redirect
      must_redirect_to passengers_path
    end

    it "works for a passenger that exists" do
      get passenger_path(@passenger.id)

      must_respond_with :ok
    end
  end

  describe "new" do
    it "returns status code 200" do
      get new_passenger_path
      must_respond_with :ok
    end
  end

  describe "create" do
    it "creates a new passenger" do
      # Arrange
      passenger_data = {
        passenger: {
          name: "donald duck",
          phone_num: "123-456-7890",
        },
      }

      # Act
      expect {
        post passengers_path, params: passenger_data
      }.must_change "Passenger.count", +1

      # Assert
      must_respond_with :redirect
      must_redirect_to passengers_path

      passenger = Passenger.last
      expect(passenger.name).must_equal passenger_data[:passenger][:name]
      expect(passenger.phone_num).must_equal passenger_data[:passenger][:phone_num]

      # passenger_data[:passenger].keys.each do |key|
      #   expect(passenger.attributes[key]).must_equal passenger_data[:passenger][key]
      # end
    end

    it "sends back bad_request if no passenger data is sent" do
      passenger_data = {
        passenger: {
          name: "",
        },
      }
      expect(Passenger.new(passenger_data[:passenger]).valid?).must_equal false

      # Act
      expect {
        post passengers_path, params: passenger_data
      }.wont_change "Passenger.count"

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with OK for a real passenger" do
      get edit_passenger_path(@passenger)
      must_respond_with :ok
    end

    it "responds with redirect for a fake passenger" do
      passenger_id = Passenger.last.id + 1
      get edit_passenger_path(passenger_id)
      must_respond_with :redirect
      must_redirect_to passengers_path
    end
  end

  describe "update" do
    let(:passenger_data) {
      {
        passenger: {
          name: "updated name",
        },
      }
    }
    it "changes the data on the model" do
      # Assumptions
      @passenger.assign_attributes(passenger_data[:passenger])
      expect(@passenger).must_be :valid?
      @passenger.reload

      # Act
      patch passenger_path(@passenger), params: passenger_data

      # Assert
      must_respond_with :redirect
      must_redirect_to passenger_path(@passenger)

      @passenger.reload
      expect(@passenger.name).must_equal(passenger_data[:passenger][:name])
    end

    it "responds with NOT FOUND for a fake passenger" do
      passenger_id = Passenger.last.id + 1
      patch passenger_path(passenger_id), params: passenger_data
      must_respond_with :not_found
    end

    it "responds with BAD REQUEST for bad data" do
      # Arrange
      passenger_data[:passenger][:name] = ""

      # Assumptions
      @passenger.assign_attributes(passenger_data[:passenger])
      expect(@passenger).wont_be :valid?
      @passenger.reload

      # Act
      patch passenger_path(@passenger), params: passenger_data

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "removes the passenger from the database" do
      # Act
      expect {
        delete passenger_path(@passenger)
      }.must_change "Passenger.count", -1

      # Assert
      must_respond_with :redirect
      must_redirect_to passengers_path

      after_passenger = Passenger.find_by(id: @passenger.id)
      expect(after_passenger).must_be_nil
    end

    it "returns a 404 if the passenger does not exist" do
      # Arrange
      passenger_id = 123456

      # Assumptions
      expect(Passenger.find_by(id: passenger_id)).must_be_nil

      # Act
      expect {
        delete passenger_path(passenger_id)
      }.wont_change "Passenger.count"

      # Assert
      must_respond_with :not_found
    end
  end
end

require "test_helper"
require "pry"

# validation for name and phone number

describe DriversController do
  before do
    # @trip = Trip.create!(name: "test trip")
    @driver = Driver.create!(name: "snoopy", vin: "111111111")
  end
  describe "index" do
    it "renders without crashing" do
      # Arrange

      # Act
      get drivers_path

      # Assert
      must_respond_with :ok
    end

    it "renders even if there are zero drivers" do
      # Arrange
      @driver.destroy

      # Act
      get drivers_path

      # Assert
      must_respond_with :ok
    end
  end

  describe "show" do
    it "redirects to drivers path if the driver doesn't exist" do
      driver_id = 12345

      get driver_path(driver_id)
      must_respond_with :redirect
      must_redirect_to drivers_path
    end

    it "works for a driver that exists" do
      get driver_path(@driver.id)

      must_respond_with :ok
    end
  end

  describe "new" do
    it "returns status code 200" do
      get new_driver_path
      must_respond_with :ok
    end
  end

  describe "create" do
    it "creates a new driver" do
      # Arrange
      driver_data = {
        driver: {
          name: "charlie brown",
          vin: "1212121212",
        },
      }

      # Act
      expect {
        post drivers_path, params: driver_data
      }.must_change "Driver.count", +1

      # Assert
      must_respond_with :redirect
      must_redirect_to drivers_path

      driver = Driver.last
      expect(driver.name).must_equal driver_data[:driver][:name]
      expect(driver.vin).must_equal driver_data[:driver][:vin]

      # passenger_data[:passenger].keys.each do |key|
      #   expect(passenger.attributes[key]).must_equal passenger_data[:passenger][key]
      # end
    end

    it "sends back bad_request if no driver data is sent" do
      driver_data = {
        driver: {
          vin: "",
        },
      }
      expect(Driver.new(driver_data[:driver]).valid?).must_equal false

      # Act
      expect {
        post drivers_path, params: driver_data
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with OK for a real driver" do
      get edit_driver_path(@driver)
      must_respond_with :ok
    end

    it "responds with redirect for a fake driver" do
      driver_id = Driver.last.id + 1
      get edit_driver_path(driver_id)
      must_respond_with :redirect
      must_redirect_to drivers_path
    end
  end

  describe "update" do
    let(:driver_data) {
      {
        driver: {
          name: "updated name",
        },
      }
    }
    it "changes the data on the model" do
      # Assumptions
      @driver.assign_attributes(driver_data[:driver])
      expect(@driver).must_be :valid?
      @driver.reload

      # Act
      patch driver_path(@driver), params: driver_data

      # Assert
      must_respond_with :redirect
      must_redirect_to driver_path(@driver)

      @driver.reload
      expect(@driver.name).must_equal(driver_data[:driver][:name])
    end

    it "responds with NOT FOUND for a fake driver" do
      driver_id = Driver.last.id + 1
      patch driver_path(driver_id), params: driver_data
      must_respond_with :not_found
    end

    it "responds with BAD REQUEST for bad data" do
      # Arrange
      driver_data[:driver][:vin] = ""

      # Assumptions
      @driver.assign_attributes(driver_data[:driver])
      expect(@driver).wont_be :valid?
      @driver.reload

      # Act
      patch driver_path(@driver), params: driver_data

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "removes the driver from the database" do
      # Act
      expect {
        delete driver_path(@driver)
      }.must_change "Driver.count", -1

      # Assert
      must_respond_with :redirect
      must_redirect_to drivers_path

      after_driver = Driver.find_by(id: @driver.id)
      expect(after_driver).must_be_nil
    end

    it "returns a 404 if the driver does not exist" do
      # Arrange
      driver_id = 123456

      # Assumptions
      expect(Driver.find_by(id: driver_id)).must_be_nil

      # Act
      expect {
        delete driver_path(driver_id)
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :not_found
    end
  end
end

class DriversController < ApplicationController
    def index
        @drivers = Driver.all
      end
    
      def show
        driver_id = params[:id]
        @driver = Driver.find_by(id: driver_id)
        unless @driver
          redirect_to drivers_path
        end
      end
    
      def new
        @driver = Driver.new
      end
    
      def create
        puts "successfully created"
        @driver = Driver.new(driver_params)
    
        if @driver.save
          redirect_to drivers_path
        else
          render :new, status: :bad_request
        end
      end
    
      def edit
        driver_id = params[:id]
        @driver = Driver.find_by(id: driver_id)
    
        unless @driver
          redirect_to drivers_path
        end
      end
    
      def update
        @driver = Driver.find_by(id: params[:id])
    
        unless @driver
          head :not_found
          return
        end
    
        unless @driver.update(driver_params)
          render :edit, status: :bad_request
          return
        else
          redirect_to driver_path(@driver)
        end
      end
    
      def destroy
        driver_id = params[:id]
    
        driver = Driver.find_by(id: driver_id)
    
        unless driver
          head :not_found
          return
        end
    
        driver.destroy
    
        redirect_to drivers_path
      end
    
      private
    
      def driver_params
        return params.require(:driver).permit(:name, :vin)
      end   
    end
end 


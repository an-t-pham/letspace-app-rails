class PropertiesController < ApplicationController

    def new
        @property = Property.new(landlord_id: params[:landlord_id])
        @available_tenants = Tenant.all.select {|tenant| !tenant.property}
    end

    def index
        @properties = Property.all
    end

    def show
        @property = Property.find(params[:id])
    end

    def edit
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
        @available_tenants = Tenant.all.select {|tenant| !tenant.property}
   
    end

    def create
        @property = Property.create(property_params)
        byebug
        @landlord = @property.landlord
        redirect_to landlord_property_show_path(@landlord, @property)
    end

    def update
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
        @property.update(property_params)

        redirect_to landlord_property_show_path(@landlord, @property)
    end

    def landlord_properties
        @landlord = Landlord.find(params[:landlord_id])
        @properties = @landlord.properties
    end

    def landlord_property
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
        
    end

    private
    def property_params
        params.require(:user).permit(:address, :price, :description, :image_url)
    end
    
end

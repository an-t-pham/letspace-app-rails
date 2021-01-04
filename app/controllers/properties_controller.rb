class PropertiesController < ApplicationController

    def new
        @property = Property.new(landlord_id: params[:landlord_id])
        @landlord = Landlord.find(params[:landlord_id])
        @available_tenants = Tenant.all.select {|tenant| !tenant.property}
    end

    def index
        @properties = Property.all.select {|property| !property.tenant}
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
        @landlord = Landlord.find(params[:landlord_id])
        @property = @landlord.properties.build(property_params)
        @property.save
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

    def destroy
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
        if @property.tenant
            @property.tenant_id = nil
            @property.save
       
          #flash[:notice] = "Property deleted."
        end
        @property.destroy
        
        redirect_to landlord_properties_show_path
    end


    private
    def property_params
        params.require(:property).permit(:address, :price, :description, :image_url)
    end
    
end

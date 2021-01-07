class PropertiesController < ApplicationController
    @@tenant_id

    def new
        @property = Property.new(landlord_id: params[:landlord_id])
        @landlord = Landlord.find(params[:landlord_id])
        @available_tenants = Tenant.all.select {|tenant| !tenant.property}
        @url = landlord_properties_show_path
    end

    def index
        @properties = Property.all.select {|property| !property.tenant}
        @tenant = Tenant.find(session[:tenant_id])
    end

    def show
        @property = Property.find(params[:id])
        @reviews = Review.all.select {|review| review.property_id == @property.id}
        @tenant = Tenant.find(session[:tenant_id])
    end

    def edit
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
        @available_tenants = Tenant.all.select {|tenant| !tenant.property} 
        @@tenant_id = @property.tenant_id 
        tenant = Tenant.find(@@tenant_id) if @@tenant_id
   
        tenant ? @available_tenants << tenant : @available_tenants 
        @url = landlord_property_show_path(@landlord, @property)
 
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
        @previous_tenant = Tenant.find(@@tenant_id) if @@tenant_id
        @property.update(property_params)
        if  @@tenant_id && @@tenant_id != @property.tenant_id && !@property.previous_tenants.include?(@previous_tenant)
               @property.previous_tenants << @previous_tenant
               @property.save
        end

        redirect_to landlord_property_show_path(@landlord, @property)
    end

    def landlord_properties
        @landlord = Landlord.find(params[:landlord_id])
        @properties = @landlord.properties
    end

    def landlord_property
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
        @reviews = Review.all.select {|review| review.property_id == @property.id}
    end

    def tenant_property
        @tenant = Tenant.find(params[:tenant_id])
        @property = Property.find(params[:id])
        @review = Review.find_by(tenant_id: params[:tenant_id], property_id: params[:id])
    end

    def destroy
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
        if @property.tenant
            @property.tenant_id = nil
            @property.save
       
          #flash[:notice] = "Property deleted."
        end
        @property.reviews.destroy_all
        @property.destroy
        
        redirect_to landlord_properties_show_path
    end


    private
    def property_params
        params.require(:property).permit(:address, :price, :description, :image_url, :tenant_id)
    end
    
end

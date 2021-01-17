class PropertiesController < ApplicationController
    before_action :landlord_require_login, only: [:new, :create, :edit, :update, :destroy, :landlord_property, :landlord_properties]
    before_action :tenant_require_login, only: [:tenant_property]
    @@tenant_id

    def new
           @landlord = Landlord.find_by_id(params[:landlord_id])
           if landlord_authorized?(@landlord)
              @property = Property.new(landlord_id: params[:landlord_id])
              @available_tenants = Tenant.all.select {|tenant| !tenant.property}
              @url = landlord_properties_show_path
              render :new
           else 
            landlord_not_authorized
           end
    end

    def create
           @landlord = Landlord.find_by_id(params[:landlord_id])
            if landlord_authorized?(@landlord)
              @property = @landlord.properties.build(property_params)
              if @property.save
                  redirect_to landlord_property_show_path(@landlord, @property)
              else
                @available_tenants = Tenant.all.select {|tenant| !tenant.property}
                render :new
              end
           else
            landlord_not_authorized
           end

    end

    def index
        if logged_in?
            if session[:filter_properties] == "Highest Rating"
               @properties = Property.order_by_high_rating.select {|property| !property.tenant}
            elsif session[:filter_properties] == "Lowest Rating"
                @properties = Property.order_by_low_rating.select {|property| !property.tenant}
            elsif session[:filter_properties] == "Cheapest"
               @properties = Property.order_by_cheap.select {|property| !property.tenant}
            elsif session[:filter_properties] == "Most Expensive"
                @properties = Property.order_by_expensive.select {|property| !property.tenant}
            else
                @properties = Property.all.select {|property| !property.tenant}
            end
           @property = Property.new
           @tenant = Tenant.find(session[:tenant_id]) if session[:tenant_id]
           @landlord = Landlord.find(session[:landlord_id]) if session[:landlord_id]
        else
           flash[:error] = "Please log in or sign up to view available properties!"
           redirect_to root_path
        end
    end

    def filter_properties
        session[:filter_properties] = params[:property][:filter] if params[:property][:filter]
        redirect_to properties_path
    end

    def show
        if logged_in?
          @property = Property.find(params[:id])
          @reviews = Review.all.select {|review| review.property_id == @property.id}
        else
           flash[:error] = "Please log in or sign up to view the property!"
           redirect_to root_path
        end
    end

    def edit
           @landlord = Landlord.find_by_id(params[:landlord_id])
           @property = Property.find_by_id(params[:id])
              if authorized_to_edit?(@property)
                  @available_tenants = Tenant.all.select {|tenant| !tenant.property} 
                  @@tenant_id = @property.tenant_id 
                  tenant = Tenant.find(@@tenant_id) if @@tenant_id
                  tenant ? @available_tenants << tenant : @available_tenants 
                  @url = landlord_property_show_path(@landlord, @property)
              else
                  flash[:error] = "Not authorized to edit this property!"
                  landlord_or_tenant_path
              end
 
    end

    

    def update
          @landlord = Landlord.find_by_id(params[:landlord_id])
          @property = Property.find_by_id(params[:id])
            if authorized_to_edit?(@property)
              @previous_tenant = Tenant.find(@@tenant_id) if @@tenant_id
              @property.update(property_params)
                if  @@tenant_id && @@tenant_id != @property.tenant_id && !@property.previous_tenants.include?(@previous_tenant)
                  @property.previous_tenants << @previous_tenant
                  @property.save
                end
                redirect_to landlord_property_show_path(@landlord, @property)
             else
                flash[:error] = "Not authorized to edit this property!"
                landlord_or_tenant_path
             end
    end

    def landlord_properties
           @landlord = Landlord.find_by_id(params[:landlord_id])
           if landlord_authorized?(@landlord)
              @properties = @landlord.properties
           else
            landlord_not_authorized
           end
    end

    def landlord_property
          @landlord = Landlord.find_by_id(params[:landlord_id])
          @property = Property.find_by_id(params[:id])
          if authorized_to_edit?(@property)
             @reviews = Review.all.select {|review| review.property_id == @property.id}
          else
            landlord_not_authorized
          end
    end

    def tenant_property
           @tenant = Tenant.find_by_id(params[:tenant_id])
           if tenant_authorized?(@tenant)
              @property = Property.find_by_id(params[:id])
              if authorized_to_review?(@property)
                @review = Review.find_by(tenant_id: params[:tenant_id], property_id: params[:id])
                @reviews = Review.all.select {|review| review.property_id == @property.id}
              else
                flash[:error] = "Not authorzied to review this property"
                redirect_to property_path(@property)
              end
           else
              tenant_not_authorized
           end
    end

  

    def destroy
           @landlord = Landlord.find_by_id(params[:landlord_id])
           @property = Property.find_by_id(params[:id])
           if landlord_authorized?(@landlord) && authorized_to_edit?(@property)
              if @property.tenant
                  @property.tenant_id = nil
                  @property.save
              end
            @property.destroy
            flash[:message] = "Property deleted."
            redirect_to landlord_properties_show_path(@landlord)
           else
            landlord_not_authorized
           end
    end

    private
    def property_params
        params.require(:property).permit(:address, :price, :description, :image_url, :tenant_id)
    end
    
end

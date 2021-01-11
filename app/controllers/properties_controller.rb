class PropertiesController < ApplicationController
    @@tenant_id

    def new
        if landlord_logged_in?
           @landlord = Landlord.find_by_id(params[:landlord_id])
           if landlord_authorized?(@landlord)
              @property = Property.new(landlord_id: params[:landlord_id])
              @available_tenants = Tenant.all.select {|tenant| !tenant.property}
              @url = landlord_properties_show_path
              render :new
           else 
              flash[:error] = "Not authorized to access this profile!"
              redirect_to landlord_path(@landlord)
           end
        else
          flash[:error] = "You're not logged in as a landlord!"
          if tenant_logged_in?
            tenant = Tenant.find_by_id(session[:tenant_id])
            redirect_to tenant_path(tenant)
          else
              redirect_to login_path
          end
        end
    end

    def index
        if logged_in?
           @properties = Property.all.select {|property| !property.tenant}
           @tenant = Tenant.find(session[:tenant_id]) if session[:tenant_id]
           @landlord = Landlord.find(session[:landlord_id]) if session[:landlord_id]
        else
           flash[:error] = "Please log in or sign up to view available properties!"
           redirect_to root_path
        end
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
        if landlord_logged_in?
           @landlord = Landlord.find_by_id(params[:landlord_id])
           if landlord_authorized?(@landlord)
               @property = Property.find_by_id(params[:id])
               @available_tenants = Tenant.all.select {|tenant| !tenant.property} 
               @@tenant_id = @property.tenant_id 
               tenant = Tenant.find(@@tenant_id) if @@tenant_id
   
               tenant ? @available_tenants << tenant : @available_tenants 
               @url = landlord_property_show_path(@landlord, @property)
           else
               flash[:error] = "Not authorized to edit this property!"
               redirect_to landlord_path(@landlord)
           end

        else
            flash[:error] = "Not authorized to edit this property!"
            if tenant_logged_in?
                tenant = Tenant.find_by_id(session[:tenant_id])
                redirect_to tenant_path(tenant)
              else
                  redirect_to login_path
              end
        end
 
    end

    def create
        if landlord_logged_in?
           @landlord = Landlord.find_by_id(params[:landlord_id])
            if landlord_authorized?(@landlord)
              @property = @landlord.properties.build(property_params)
              if @property.save
                  redirect_to landlord_property_show_path(@landlord, @property)
              else
                  redirect_to new_landlord_property_path(@landlord)
              end
           else
              flash[:error] = "Not authorized to access this profile!"
              redirect_to landlord_path(@landlord)
           end
        else
            flash[:error] = "Not authorized to create this property!"
            if tenant_logged_in?
                tenant = Tenant.find_by_id(session[:tenant_id])
                redirect_to tenant_path(tenant)
            else
                  redirect_to login_path
            end
        end

    end

    def update
        if landlord_logged_in?
          @landlord = Landlord.find_by_id(params[:landlord_id])
          if landlord_authorized?(@landlord)
             @property = Property.find_by_id(params[:id])
             @previous_tenant = Tenant.find(@@tenant_id) if @@tenant_id
             @property.update(property_params)
             if  @@tenant_id && @@tenant_id != @property.tenant_id && !@property.previous_tenants.include?(@previous_tenant)
               @property.previous_tenants << @previous_tenant
               @property.save
             end
             redirect_to landlord_property_show_path(@landlord, @property)

            else
              flash[:error] = "Not authorized to access this profile!"
              redirect_to landlord_path(@landlord)
          end

        else
            flash[:error] = "Not authorized to edit this property!"
            if tenant_logged_in?
                tenant = Tenant.find_by_id(session[:tenant_id])
                redirect_to tenant_path(tenant)
              else
                  redirect_to login_path
              end
        end
    end

    def landlord_properties
        if landlord_logged_in?
           @landlord = Landlord.find(params[:landlord_id])
           if landlord_authorized?(@landlord)
              @properties = @landlord.properties
           else
              flash[:error] = "Not authorized to access this profile!"
              redirect_to landlord_path(@landlord)
           end
        else
            flash[:error] = "Not authorized to access this profile!"
            if tenant_logged_in?
                tenant = Tenant.find_by_id(session[:tenant_id])
                redirect_to tenant_path(tenant)
            else
                  redirect_to login_path
            end
        end
    end

    def landlord_property
        if landlord_logged_in?
          @landlord = Landlord.find(params[:landlord_id])
          if landlord_authorized?(@landlord)
             @property = Property.find(params[:id])
             @reviews = Review.all.select {|review| review.property_id == @property.id}
          else
            flash[:error] = "Not authorized to access this profile!"
            redirect_to landlord_path(@landlord)
          end

        else
            flash[:error] = "Not authorized to access this profile!"
            if tenant_logged_in?
                tenant = Tenant.find_by_id(session[:tenant_id])
                redirect_to tenant_path(tenant)
            else
                  redirect_to login_path
            end
        end
    end

    def tenant_property
        if tenant_logged_in?
           @tenant = Tenant.find(params[:tenant_id])
           if tenant_authorized?(@tenant)
              @property = Property.find(params[:id])
              @review = Review.find_by(tenant_id: params[:tenant_id], property_id: params[:id])
           else
              flash[:error] = "Not authorized to access this profile!"
              redirect_to tenant_path(@tenant)
           end
        else
            flash[:error] = "Not authorized to access this profile!"
            if landlord_logged_in?
                landlord = Landlord.find_by_id(session[:landlord_id])
                redirect_to landlord_path(landlord)
            else
                  redirect_to login_path
            end
        end
    end

    def destroy
        if landlord_logged_in?
           @landlord = Landlord.find(params[:landlord_id])
           if landlord_authorized?(@landlord)
              @property = Property.find(params[:id])
              if @property.tenant
                  @property.tenant_id = nil
                  @property.save
              end
            @property.reviews.destroy_all
            @property.destroy
            flash[:message] = "Property deleted."
            redirect_to landlord_properties_show_path(@landlord)
           else
              flash[:error] = "Not authorized to delete this property!"
              redirect_to landlord_path(@landlord)
           end
        else
            flash[:error] = "Not authorized to access this profile!"
            if tenant_logged_in?
                tenant = Tenant.find_by_id(session[:tenant_id])
                redirect_to tenant_path(tenant)
            else
                  redirect_to login_path
            end
        end
    end


    private
    def property_params
        params.require(:property).permit(:address, :price, :description, :image_url, :tenant_id)
    end
    
end

class UsersController < ApplicationController
    before_action :require_login, only: [:edit, :update, :destroy]
    before_action :find_user, only: [:edit, :update, :destroy]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            if @user.landlord_checkbox
                landlord = Landlord.create(user_id: @user.id)
                session[:landlord_id] = landlord.id 
                redirect_to landlord_path(landlord)
            else
                tenant = Tenant.create(user_id: @user.id)
                session[:tenant_id] = tenant.id 
                redirect_to tenant_path(tenant)
            end
        else
            render :new
        end
            
    end

    def edit
          if user_authorized?(@user)
             @edit = true 
             render :edit
          else 
            @user = User.find_by_id(session[:user_id])
            flash[:error] = "Not authorized to access this profile!"
            landlord_or_tenant_path
          end
       
    end

    def update
          if user_authorized?(@user)
             @user.update(user_params)
             landlord_or_tenant_path
          else
            @user = User.find_by_id(session[:user_id])
            flash[:error] = "Not authorized to access this profile!"

            landlord_or_tenant_path
          end
       
    end

    def landlord_tenant
        @user = User.find_by_id(session[:user_id])
        @user.update(landlord_tenant_params)
        if @user.landlord_checkbox
            landlord = Landlord.create(user_id: @user.id)
            session[:landlord_id] = landlord.id 
            redirect_to landlord_path(landlord)
        else
            tenant = Tenant.create(user_id: @user.id)
            session[:tenant_id] = tenant.id 
            redirect_to tenant_path(tenant)
        end
    end

    def destroy
          if user_authorized?(@user)
             if @user.tenant && @user.tenant.property
                    @user.tenant.property.tenant_id = nil 
                    @user.tenant.property.save
             end
             @user.destroy
             reset_session
             flash[:message] = "Account deleted."
             redirect_to root_path
          else
            @user = User.find_by_id(session[:user_id])
            flash[:error] = "Not authorized to access this profile!"

            landlord_or_tenant_path
          end
      
        
    end



    private
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :bio, :image_url, :landlord_checkbox)
    end
   
    def landlord_tenant_params
        params.require(:user).permit(:landlord_checkbox)
    end
    

    def find_user
        @user = User.find_by_id(params[:id])
        if !@user 
            flash[:error] = "Profile was not found"
            landlord_or_tenant_path
        end
    end
end
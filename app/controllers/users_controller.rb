class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
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
        if logged_in?
          @user = User.find_by_id(params[:id])

          if user_authorized?(@user)
             @edit = true 
             render :edit
          else 
            @user = User.find(session[:user_id])
            flash[:error] = "Not authorized to access this profile!"

            if @user.landlord_checkbox
                @landlord = Landlord.find_by(user_id: @user.id)
                redirect_to landlord_path(@landlord)
            else
                @tenant = Tenant.find_by(user_id: @user.id)
                redirect_to tenant_path(@tenant)
            end
          end
        
        else
          flash[:error] = "You're not logged in!"
          redirect_to login_path
        end
    end

    def update
        if logged_in?
          @user = User.find_by_id(params[:id])
          if user_authorized?(@user)
             @user.update(user_params)
             if @user.landlord 
                 landlord = Landlord.find_by(user_id: @user.id)

                 redirect_to landlord_path(landlord)
             else
                 tenant = Tenant.find_by(user_id: @user.id)
        
                 redirect_to tenant_path(tenant)
             end
          else
            @user = User.find_by_id(session[:user_id])
            flash[:error] = "Not authorized to access this profile!"

            if @user.landlord_checkbox
                @landlord = Landlord.find_by(user_id: @user.id)
                redirect_to landlord_path(@landlord)
            else
                @tenant = Tenant.find_by(user_id: @user.id)
                redirect_to tenant_path(@tenant)
            end
          end
        else
          
        end
    end

    def destroy
        if logged_in?
          @user = User.find_by_id(params[:id])
          if user_authorized?(@user)
             if @user.tenant 
               @user.tenant.property.tenant_id = nil if @user.tenant.property.tenant_id
               @user.tenant.property.save
             else
                @user.landlord.properties.each {|property| property.reviews.destroy_all}
                @user.landlord.properties.destroy_all
             end
             @user.destroy
             flash[:message] = "Account deleted."
             redirect_to root_path
          else
            @user = User.find_by_id(session[:user_id])
            flash[:error] = "Not authorized to access this profile!"

            if @user.landlord_checkbox
                @landlord = Landlord.find_by(user_id: @user.id)
                redirect_to landlord_path(@landlord)
            else
                @tenant = Tenant.find_by(user_id: @user.id)
                redirect_to tenant_path(@tenant)
            end
          end
          
        else
          flash[:error] = "You're not logged in!"
          redirect_to login_path
        end
    end



    private
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :bio, :image_url, :landlord_checkbox)
    end
end
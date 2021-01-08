class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            if @user.landlord 
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
        @user = User.find(params[:id])
        byebug
        @edit = true
    end

    def update
        @user = User.find(params[:id])
        @user.update(user_params)
        if @user.landlord 
            landlord = Landlord.find_by(user_id: @user.id)

            redirect_to landlord_path(landlord)
        else
            tenant = Tenant.find_by(user_id: @user.id)
        
            redirect_to tenant_path(tenant)
        end
    end

    def destroy
        @user = User.find(params[:id])
        if @user.tenant 
           if @user.tenant.property 
              @user.tenant.property.tenant_id = nil
              @user.tenant.property.save
           end
           @user.tenant.reviews.destroy_all
        else
            @user.landlord.properties.each {|property| property.reviews.destroy_all}
            @user.landlord.properties.destroy_all
        end
        @user.destroy
        #flash[:notice] = "Account deleted."
        redirect_to root_path
    end



    private
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password_digest, :bio, :image_url)
    end
end
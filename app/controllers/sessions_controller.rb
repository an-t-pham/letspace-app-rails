class SessionsController < ApplicationController

    def welcome
    end

    def new
        @user = User.new
      end
    
      def create
        @user = User.find_by(email: params[:user][:email])
        if @user && @user.authenticate(params[:user][:password])
            if @user.landlord
                landlord = Landlord.find_by(user_id: @user.id)
                session[:landlord_id] = landlord.id

                redirect_to landlord_path(landlord)
            else 
                tenant = Tenant.find_by(user_id: @user.id)
                session[:tenant_id] = tenant.id

                redirect_to tenant_path(tenant)
            end
        else
          flash[:error] = "Your email and/or password were invalid. Please try again!"
          redirect_to login_path
        end
      end
    
      def destroy
        session[:landlord_id] ? session.delete("landlord_id") : session.delete("tenant_id")
        redirect_to root_path
      end

end

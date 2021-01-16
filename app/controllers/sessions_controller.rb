class SessionsController < ApplicationController

    def welcome
    end

    def new
      if !logged_in?
        @user = User.new
      else
        landlord_or_tenant_path
      end
    end

      def create
        @user = User.find_by(email: params[:user][:email])
        if @user && @user.authenticate(params[:user][:password])
          session[:user_id] = @user.id
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

      # def omniauth
      #    byebug
      # end
    
      def destroy
        # byebug
        reset_session
        # session.delete("landlord_id") if session[:landlord_id]
        # session.delete("tenant_id") if session[:tenant_id]
        # session.delete("user_id") if session[:user_id]
        redirect_to root_path
      end

end

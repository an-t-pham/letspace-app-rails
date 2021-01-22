class SessionsController < ApplicationController

    def welcome
    end

    def new
      if !logged_in?
        @user = User.new
      else
        flash[:error] = "You're already logged in!"
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

      def omniauth
         @user = User.find_by(email: auth[:info][:email])
         
         if @user
          session[:user_id] = @user.id
           if @user.landlord_checkbox
              landlord = Landlord.find_by(user_id: @user.id)
              session[:landlord_id] = landlord.id
              redirect_to landlord_path(landlord)
           else
              tenant = Tenant.find_by(user_id: @user.id)
              session[:tenant_id] = tenant.id
              redirect_to tenant_path(tenant)
            end
         else
            @user = User.create(email: auth[:info][:email]) do |user|
              user.first_name = auth.info.first_name
              user.last_name = auth.info.last_name
              user.image_url = auth.info.image
              user.landlord_checkbox = false
              user.password = SecureRandom.hex
            end
            session[:user_id] = @user.id
            render :landlord_or_tenant
          end
     end


      def destroy
        reset_session
        redirect_to root_path
      end

      private

      def auth
        request.env['omniauth.auth']
      end

      def session_params
        params.require(:controller).permit(:session)
    end

end

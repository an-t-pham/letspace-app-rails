class SessionsController < ApplicationController

    def new
        @user = User.new
      end
    
      def create
        if @user = User.find_by(email: params[:user][:email])
            if @user.landlord
                landlord = Landlord.find(@user.id)
                session[:landlord_id] = landlord.id

                redirect_to landlord_path(landlord)
            else 
                tenant = Tenant.find_by(user_id: @user.id)
                session[:tenant_id] = tenant.id

                redirect_to tenant_path(tenant)
            end
        else
            render :new
        end
      end
    
      def destroy
        session[:landlord_id] ? session.delete("landlord_id") : session.delete("tenant_id")
        redirect_to root_path
      end

end

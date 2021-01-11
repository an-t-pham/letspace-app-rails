class TenantsController < ApplicationController

    def show
        if tenant_logged_in?
            @tenant = Tenant.find(params[:id])
            if tenant_authorized?(@tenant)
                @user = @tenant.user
                render :show
            else
               @tenant = Tenant.find(session[:tenant_id])
               flash[:error] = "Not authorized to access this profile!"
               redirect_to tenant_path(@tenant)
            end
         else
            flash[:error] = "You're not logged in as this tenant!"
            if landlord_logged_in?
               landlord = Landlord.find_by_id(session[:landlord_id])
               redirect_to landlord_path(landlord)
             else
                 redirect_to login_path
             end
         end   
    end

    def edit
      if tenant_logged_in?
        @tenant = Tenant.find(params[:id])
        if tenant_authorized?(@tenant)
           @user = @tenant.user
           redirect_to edit_user_path(@user)
        else
            @tenant = Tenant.find(session[:tenant_id])
            flash[:error] = "Not authorized to access this profile!"
            redirect_to tenant_path(@tenant)
        end
      else
         flash[:error] = "You're not logged in as this tenant!"
         if landlord_logged_in?
            landlord = Landlord.find_by_id(session[:landlord_id])
            redirect_to landlord_path(landlord)
          else
              redirect_to login_path
          end
      end
   end
end

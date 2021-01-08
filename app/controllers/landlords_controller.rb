class LandlordsController < ApplicationController

   def show
      if landlord_logged_in?
         @landlord = Landlord.find(session[:landlord_id])
         if landlord_authorized?(@landlord)
            @user = @landlord.user
            render :show
         else
            @landlord = Landlord.find(session[:landlord_id])
            flash[:error] = "Not authorized to access this profile!"
            redirect_to landlord_path(@landlord)
         end
      else
         flash[:error] = "You're not logged in!"
         redirect_to login_path
      end   
   end

   def edit
      if landlord_logged_in?
        @landlord = Landlord.find(params[:id])
        if landlord_authorized?(@landlord)
           @user = @landlord.user
           redirect_to edit_user_path(@user)
        else
            @landlord = Landlord.find(session[:landlord_id])
            flash[:error] = "Not authorized to access this profile!"
            redirect_to landlord_path(@landlord)
        end
      else
        flash[:error] = "You're not logged in!"
        redirect_to login_path
      end
   end
   
  

end

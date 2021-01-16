class LandlordsController < ApplicationController
   before_action :landlord_require_login, only: [:show, :edit]

   def show
         @landlord = Landlord.find_by_id(params[:id])
         if landlord_authorized?(@landlord)
            @user = @landlord.user
            render :show
         else
            landlord_not_authorized
         end
     
   end

   def edit
        @landlord = Landlord.find_by_id(params[:id])
        if landlord_authorized?(@landlord)
           @user = @landlord.user
           redirect_to edit_user_path(@user)
        else
            landlord_not_authorized
        end
      
   end

  

end

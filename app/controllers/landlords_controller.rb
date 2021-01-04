class LandlordsController < ApplicationController

   def show
     @landlord = Landlord.find(params[:id])
     @user = @landlord.user
   end

   def edit
      @landlord = Landlord.find(params[:id])
      @user = @landlord.user
      redirect_to edit_user_path(@user)
   end
   
  

end

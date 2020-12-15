class LandlordsController < ApplicationController

   def show
     @landlord = Landlord.find(params[:id])
   end
end

class TenantsController < ApplicationController

    def show
        @user = Tenant.find(params[:id]).user
        
    end

    def edit
      @tenant = Tenant.find(params[:id])

      @user = @tenant.user

      redirect_to edit_user_path(@user)
   end
end

class TenantsController < ApplicationController
    before_action :tenant_require_login, only: [:show, :edit]

    def show
        @tenant = Tenant.find(params[:id])
            if tenant_authorized?(@tenant)
                @user = @tenant.user
                render :show
            else
                tenant_not_authorized
            end
    end

    def edit
        @tenant = Tenant.find(params[:id])
           if tenant_authorized?(@tenant)
              @user = @tenant.user
              redirect_to edit_user_path(@user)
           else
               tenant_not_authorized
           end
    end
    
end

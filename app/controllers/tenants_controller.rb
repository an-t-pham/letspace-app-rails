class TenantsController < ApplicationController

    def show
        @tenant = Tenant.find(params[:id])
      end
end

class ApplicationController < ActionController::Base
   helper_method :current_user, :logged_in?, :current_landlord, :landlord_logged_in?, :current_tenant, :tenant_logged_in?, :require_login

    private
        def current_user
           @current_user ||= User.find_by(id: session[:user_id])
        end

        def logged_in?
           !!current_user
        end

        def user_authorized?(user)
           user == current_user
      end

        def current_landlord
            @current_landlord ||= Landlord.find_by(id: session[:landlord_id])
        end
      
        def landlord_logged_in?
            !!current_landlord
        end
        
        def landlord_authorized?(landlord)
           landlord == current_landlord
        end

        def authorized_to_edit?(property)
           property.landlord == current_landlord
        end

        def current_tenant
           Tenant.find_by(id: session[:tenant_id])
        end
    
        def tenant_logged_in?
           !!current_tenant
        end
      
        def tenant_authorized?(tenant)
           tenant == current_tenant
        end

        def authorized_to_review?(property)
          property.previous_tenants.find{|tenant| tenant.id == current_tenant.id} || property.tenant == current_tenant
        end

        def authorized_to_edit_review?(review)
          review.tenant == current_tenant
        end

        def require_login
           if !logged_in? 
             flash[:error] = "You're not logged in!"
             redirect_to login_path 
           end
        end
       
       def landlord_require_login
         if !landlord_logged_in?
            flash[:error] = "You're not logged in as this landlord!"
            if tenant_logged_in?
               tenant = Tenant.find_by_id(session[:tenant_id])
               redirect_to tenant_path(tenant)
             else
                 redirect_to login_path
             end
         end
      end

       
       def landlord_not_authorized
          @landlord = Landlord.find(session[:landlord_id])
          flash[:error] = "Not authorized to access this profile!"
          redirect_to landlord_path(@landlord)
       end


       def tenant_require_login
         if !tenant_logged_in?
            flash[:error] = "You're not logged in as this tenant!"
            if landlord_logged_in?
               landlord = Landlord.find_by_id(session[:landlord_id])
               redirect_to landlord_path(landlord)
             else
                 redirect_to login_path
             end
         end
       end

       def tenant_not_authorized
          @tenant = Tenant.find(session[:tenant_id])
          flash[:error] = "Not authorized to access this profile!"
          redirect_to tenant_path(@tenant)
      end

       def reset_session
         @_request.reset_session
       end

       def landlord_or_tenant_path
         if session[:landlord_id]
             landlord = Landlord.find_by_id(session[:landlord_id])
             redirect_to landlord_path(landlord)
          elsif session[:tenant_id]
             tenant = Tenant.find_by_id(session[:tenant_id])  
             redirect_to tenant_path(tenant)
          else
             redirect_to root_path
          end
     end
  
end

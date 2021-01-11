class ApplicationController < ActionController::Base

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

        def authorized_to_edit_review?(review)
          review.tenant == current_tenant
      end
   
  
end

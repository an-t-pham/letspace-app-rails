class ReviewsController < ApplicationController
    @@review_id

    def new
        if tenant_logged_in?
          @property = Property.find(params[:property_id])
          @tenant = Tenant.find(params[:tenant_id])
          if tenant_authorized?(@tenant)
            @review = Review.new(tenant_id: @tenant.id, property_id: @property.id)
            @url = tenant_previous_property_path(@tenant, @property)
          else 
            flash[:error] = "Not authorized to leave a review on this property!"
            redirect_to tenant_path(@tenant)
          end
        else
            flash[:error] = "Not authorized to access this profile!"
            if landlord_logged_in?
                landlord = Landlord.find_by_id(session[:landlord_id])
                redirect_to landlord_path(landlord)
            else
                  redirect_to login_path
            end
        end
    end

    def create
        if tenant_logged_in?
          @tenant = Tenant.find(params[:tenant_id])
          @property = Property.find(params[:property_id])
          if tenant_authorized?(@tenant)
             @review = @tenant.reviews.build(review_params)
             @review.property_id = @property.id

             if @review.save
                 redirect_to tenant_property_review_path(@tenant, @property, @review)
             else
                 flash[:error] = "Unable to add review: #{@review.errors.full_messages.to_sentence}"
                 redirect_to new_tenant_property_review_path(@tenant, @property)
             end
          else
            flash[:error] = "Not authorized to leave a review on this property!"
            redirect_to tenant_path(@tenant)
          end
        else
            flash[:error] = "Not authorized to access this profile!"
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
           @tenant = Tenant.find(params[:tenant_id])
           @property = Property.find(params[:property_id])
           @review = Review.find(params[:id])
          if authorized_to_edit_review?(@review)
            @@review_id = @review.id
            @url = tenant_previous_property_path(@tenant, @property)
          else
            flash[:error] = "Not authorized to edit this review"
            redirect_to tenant_path(@tenant)
          end
        else
            flash[:error] = "Not authorized to access this profile!"
            if landlord_logged_in?
                landlord = Landlord.find_by_id(session[:landlord_id])
                redirect_to landlord_path(landlord)
            else
                  redirect_to login_path
            end
        end
    end


    def update
        if tenant_logged_in?
           @tenant = Tenant.find(params[:tenant_id])
           @property = Property.find(params[:property_id])
           @review = Review.find(@@review_id)
           if authorized_to_edit_review?(@review)
              @review.update(review_params)
              redirect_to tenant_property_review_path(@tenant, @property, @review)
           else
              flash[:error] = "Not authorized to edit this review"
              redirect_to tenant_path(@tenant)
           end
        else
            flash[:error] = "Not authorized to access this profile!"
            if landlord_logged_in?
                landlord = Landlord.find_by_id(session[:landlord_id])
                redirect_to landlord_path(landlord)
            else
                  redirect_to login_path
            end
        end
    end

    def show
        if tenant_logged_in?
           @tenant = Tenant.find(params[:tenant_id])
           if tenant_authorized?(@tenant)
             @property = Property.find(params[:property_id])
             redirect_to tenant_property_path(@tenant, @property)
           else
              flash[:error] = "Not authorized to edit this review"
              redirect_to tenant_path(@tenant)
           end
        else
            flash[:error] = "Not authorized to access this profile!"
            if landlord_logged_in?
                landlord = Landlord.find_by_id(session[:landlord_id])
                redirect_to landlord_path(landlord)
            else
                  redirect_to login_path
            end
        end
    end

    def destroy
        @tenant = Tenant.find(params[:tenant_id])
        @property = Property.find(params[:property_id])
        @review = Review.find(params[:id])
        
        @review.destroy
        
        redirect_to tenant_previous_property_path(@tenant, @property)
    end

    private
        def review_params
            params.require(:review).permit(:rating, :title, :content)
        end
    
end

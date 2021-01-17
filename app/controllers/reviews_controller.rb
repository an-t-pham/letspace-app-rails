class ReviewsController < ApplicationController
   before_action :tenant_require_login, only: [:new, :create, :edit, :update, :destroy]
    @@review_id

    def new
          @property = Property.find(params[:property_id])
          @tenant = Tenant.find(params[:tenant_id])
          if tenant_authorized?(@tenant) && authorized_to_review?(@property)
            @review = Review.new(tenant_id: @tenant.id, property_id: @property.id)
            @url = tenant_previous_property_path(@tenant, @property)
          else 
            flash[:error] = "Not authorized to leave a review on this property!"
            redirect_to tenant_path(@tenant)
          end
    end

    def create
          @tenant = Tenant.find(params[:tenant_id])
          @property = Property.find(params[:property_id])
          if tenant_authorized?(@tenant) && authorized_to_review?(@property)
             @review = @tenant.reviews.build(review_params)
             @review.property_id = @property.id

             if @review.save
                 redirect_to tenant_property_review_path(@tenant, @property, @review)
             else
                @url = tenant_previous_property_path(@tenant, @property)
                render :new
             end
          else
            flash[:error] = "Not authorized to leave a review on this property!"
            redirect_to tenant_path(@tenant)
          end
    end
    
    def edit
           @tenant = Tenant.find(params[:tenant_id])
           @property = Property.find(params[:property_id])
           @review = Review.find(params[:id])
          review_exist?(@review)
          
          if authorized_to_edit_review?(@review)
            @@review_id = @review.id
            @url = tenant_previous_property_path(@tenant, @property)
          else
            flash[:error] = "Not authorized to edit this review"
            redirect_to tenant_path(@tenant)
          end
    end


    def update
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
    end

    def destroy
          @tenant = Tenant.find(params[:tenant_id])
          @property = Property.find(params[:property_id])
          @review = Review.find(params[:id])
          if authorized_to_edit_review?(@review)
             @review.destroy
             redirect_to tenant_previous_property_path(@tenant, @property)
          else
            flash[:error] = "Not authorized to delete this review"
            redirect_to tenant_path(@tenant)
          end
    end

    private
        def review_params
            params.require(:review).permit(:rating, :title, :content)
        end

        def review_exist?(review)
          landlord_or_tenant_path if !review
        end    

    
end

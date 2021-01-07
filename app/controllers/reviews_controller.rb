class ReviewsController < ApplicationController
    @@review_id

    def new
        @property = Property.find(params[:property_id])
        @tenant = Tenant.find(params[:tenant_id])
        @review = Review.new(tenant_id: @tenant.id, property_id: @property.id)
        @url = tenant_previous_property_path(@tenant, @property)
    end

    def create
        @tenant = Tenant.find(params[:tenant_id])
        @property = Property.find(params[:property_id])
        @review = @tenant.reviews.build(review_params)
        @review.property_id = @property.id
        @review.save
        redirect_to tenant_property_review_path(@tenant, @property, @review)
    end
    
    def edit
        @tenant = Tenant.find(params[:tenant_id])
        @property = Property.find(params[:property_id])
        @review = Review.find(params[:id])
        @@review_id = @review.id

        @url = tenant_previous_property_path(@tenant, @property)
    end


    def update
        @tenant = Tenant.find(params[:tenant_id])
        @property = Property.find(params[:property_id])
        @review = Review.find(@@review_id)
        @review.update(review_params)
        redirect_to tenant_property_review_path(@tenant, @property, @review)
    end

    def show
        @tenant = Tenant.find(params[:tenant_id])
        @property = Property.find(params[:property_id])
        redirect_to tenant_property_path(@tenant, @property)
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

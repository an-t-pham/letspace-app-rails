class ReviewsController < ApplicationController

    def new
        @property = Property.find(params[:property_id])
        @tenant = Tenant.find(params[:tenant_id])
        @review = @tenant.reviews.build
    end

    def index
    end

    def private
        def review_params
            params.require(:review).permit(:rating, :title, :content)
        end
    end
end

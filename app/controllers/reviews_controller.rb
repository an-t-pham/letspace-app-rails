class ReviewsController < ApplicationController

    def new
        @property = Property.find(params[:id])
        @review = @property.reviews.build
    end

    def index
    end
end

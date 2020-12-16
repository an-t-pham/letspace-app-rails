class PropertiesController < ApplicationController

    def new
        @property = Property.new(landlord_id: params[:landlord_id])
    end

    def index
        @properties = Property.all
    end

    def show
        @property = Property.find(params[:id])
        
    end

    def landlord_properties
        @landlord = Landlord.find(params[:landlord_id])
        @properties = @landlord.properties
    end

    def landlord_property
        @landlord = Landlord.find(params[:landlord_id])
        @property = Property.find(params[:id])
    end

    
end

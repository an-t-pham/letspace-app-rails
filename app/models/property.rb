class Property < ApplicationRecord
    belongs_to :landlord
    belongs_to :tenant, optional: true
    has_many :previous_records, dependent: :destroy
    has_many :previous_tenants, through: :previous_records, source: :tenant, dependent: :destroy
    has_many :reviews, dependent: :destroy
    
    validates :address, :price, :description, presence: true
    validates :price, numericality: {only_integer: true} 

    scope :order_by_high_rating, -> {left_joins(:reviews).group(:id).order('avg(rating) desc')}
    scope :order_by_low_rating, -> {left_joins(:reviews).group(:id).order('avg(rating) asc')}
    scope :order_by_expensive, -> {joins(:reviews).group(:id).order('price desc')}
    scope :order_by_cheap, -> {joins(:reviews).group(:id).order('price asc')}

    def filter
    end

    def average_rating
        rating = []
        self.reviews.each do |review|
            rating << review.rating
        end
        average_rating = rating.sum / rating.size
    end
end

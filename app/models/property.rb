class Property < ApplicationRecord
    belongs_to :landlord
    belongs_to :tenant
    has_many :previous_record
    has_many :tenants, through: :previous_record
    has_many :reviews
end

class Property < ApplicationRecord
    belongs_to :landlord
    has_many :tenants
    has_many :previous_records
    has_many :previous_tenants, through: :previous_records, source: :tenant
    has_many :reviews
end

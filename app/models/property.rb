class Property < ApplicationRecord
    belongs_to :landlord
    belongs_to :tenant
    has_many :previous_record
    has_many :previous_tenants, through: :previous_record, source: :tenant
    has_many :reviews
end

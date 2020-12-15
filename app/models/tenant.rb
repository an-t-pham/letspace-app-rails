class Tenant < ApplicationRecord
    has_one :property
    has_many :previous_records
    has_many :previous_properties, through: :previous_records, source: :property
    has_many :reviews
end

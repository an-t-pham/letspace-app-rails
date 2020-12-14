class Tenant < ApplicationRecord
    has_one :property
    has_many :previous_record
    has_many :previous_properties, through: :previous_record, source: :property
    has_many :reviews
end

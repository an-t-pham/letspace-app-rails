class Tenant < ApplicationRecord
    belongs_to :user
    belongs_to :property
    has_many :previous_records
    has_many :previous_properties, through: :previous_records, source: :property
    has_many :reviews
end

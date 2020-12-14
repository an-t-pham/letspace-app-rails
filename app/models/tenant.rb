class Tenant < ApplicationRecord
    has_one :property
    has_many :previous_record
    has_many :properties, through: :previous_record
    has_many :reviews
end

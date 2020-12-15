class Landlord < ApplicationRecord
    belongs_to :user
    has_many :properties
    has_many :tenants, through: :properties
end

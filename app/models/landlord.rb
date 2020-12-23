class Landlord < ApplicationRecord
    belongs_to :user
    has_many :properties, dependent: :destroy
    has_many :tenants, through: :properties
end

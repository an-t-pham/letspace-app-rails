class Property < ApplicationRecord
    belongs_to :landlord
    belongs_to :tenant, optional: true
    has_many :previous_records, dependent: :destroy
    has_many :previous_tenants, through: :previous_records, source: :tenant
    has_many :reviews

end

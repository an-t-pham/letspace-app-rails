class User < ApplicationRecord
  belongs_to :landlord
  belongs_to :tenant
end

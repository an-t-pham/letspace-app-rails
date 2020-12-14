class PreviousRecord < ApplicationRecord
  belongs_to :tenant
  belongs_to :property
end

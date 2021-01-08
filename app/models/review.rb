class Review < ApplicationRecord
  belongs_to :tenant
  belongs_to :property

  validates :rating, numericality: {only_integer: true, greater_than: 0, less_than: 6} 
  validates :title, :content, presence: true
end

class User < ApplicationRecord
    has_one :landlord, dependent: :destroy
    has_one :tenant, dependent: :destroy

    validates :email, uniqueness: true,  presence: true

    has_secure_password

    def name
        self.first_name + " " + self.last_name
    end
end

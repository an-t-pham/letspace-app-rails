class User < ApplicationRecord
    has_one :landlord
    has_one :tenant

    has_secure_password

    def name
        self.first_name + " " + self.last_name
    end
end

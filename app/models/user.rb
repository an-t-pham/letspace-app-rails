class User < ApplicationRecord
    has_many :landlords
    has_many :tenants

    def name
        self.first_name + " " + self.last_name
    end
end

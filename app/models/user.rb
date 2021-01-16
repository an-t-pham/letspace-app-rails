class User < ApplicationRecord
    has_one :landlord, dependent: :destroy
    has_one :tenant, dependent: :destroy

    validates :email, uniqueness: true,  presence: true
    validates :first_name, :last_name, presence: true

    has_secure_password

    def name
        self.first_name + " " + self.last_name
    end

    def self.from_omniauth(auth)
        where(email: auth.info.email).first_or_initialize do |user|
          user.name = auth.info.name
          user.email = auth.info.email
          user.password = SecureRandom.hex
        end
      end
end

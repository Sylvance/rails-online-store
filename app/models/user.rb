# User model
class User < ApplicationRecord
  has_secure_password
  has_many :goods
end

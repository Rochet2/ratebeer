class User < ActiveRecord::Base
  include MyModule

  has_secure_password

  validates :username, presence: true
  validates :username, uniqueness: true, length: {minimum: 3, maximum: 15}
  validates :password, length: {minimum: 4}
  validates :password, format: { with: /[A-Z]/, message: "must have at least one capital letter" }
  validates :password, format: { with: /\d/, message: "must have at least one digit" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy

end

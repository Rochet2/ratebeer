class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy

  def to_s
    "#{name}"
  end
end

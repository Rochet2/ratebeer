class Style < ActiveRecord::Base
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(n = nil)
    sorted_by_rating_in_desc_order = self.all.sort_by{ |b|
      r = -b.average_rating
      if not r or r.nan? then 0
      else r end
    }
    sorted_by_rating_in_desc_order.take(n) if n
  end
end

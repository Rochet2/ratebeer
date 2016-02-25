class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  validates :name, presence: true
  validates :year, numericality: {greater_than_or_equal_to: 1042, integer_only: true}
  validate do |b|
    errors.add(:year, "can not be higher than #{Time.now.year}") if b.year > Time.now.year
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end

  def self.top(n = nil)
    sorted_by_rating_in_desc_order = self.all.sort_by{ |b|
      r = -b.average_rating
      if not r or r.nan? then 0
      else r end
    }
    sorted_by_rating_in_desc_order.take(n) if n
  end
end

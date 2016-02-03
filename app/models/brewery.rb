class Brewery < ActiveRecord::Base
  include MyModule

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

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
end

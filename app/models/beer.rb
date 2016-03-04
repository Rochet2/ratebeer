class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style_id, presence: true

  def to_s
    "#{brewery.name}: #{name}"
  end

  def self.top(n = nil)
    sorted_by_rating_in_desc_order = self.all.includes(:ratings).sort_by{ |b|
      r = -b.average_rating
      if not r or r.nan? then 0
      else r end
    }
    sorted_by_rating_in_desc_order.take(n) if n
  end
end

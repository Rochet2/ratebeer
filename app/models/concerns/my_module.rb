module MyModule
  extend ActiveSupport::Concern

  def average_rating
    if ratings.empty? then
      return 0.0
    end
    scores = ratings.map { |rating| rating.score }
    sum = scores.inject do |sum, score|
      sum + score
    end
    return sum/ratings.count.to_f
  end
end

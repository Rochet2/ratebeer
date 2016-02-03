class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validate do |m|
    errors.add(:beer_club, "membership already exists") if Membership.find_by user_id: m.user_id, beer_club_id: m.beer_club_id
  end
end

require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when exists multiple different users with ratings" do
    let!(:user2) { FactoryGirl.create(:user, username:"Matti") }
    let!(:rating1) { FactoryGirl.create(:rating, score:10, beer:beer1, user:user) }
    let!(:rating2) { FactoryGirl.create(:rating, score:20, beer:beer2, user:user2) }

    it "all ratings show up correctly on ratings page" do
      visit ratings_path

      expect(page).to have_content "List of ratings"
      expect(page).to have_content "Number of ratings: 2"
      expect(page).to have_content "#{beer1.name}: 10"
      expect(page).to have_content "#{beer2.name}: 20"
    end

    it "user ratings show up correctly on his page" do
      visit user_path(user)

      expect(page).to have_content user.username
      expect(page).to have_content "Has made 1 rating"
      expect(page).to have_content "#{beer1.name}: 10"
      expect(page).not_to have_content "#{beer2.name}: 20"
    end

    it "user rating gets deleted when the user deletes it" do
      visit user_path(user)

      expect{
        find_link('delete').click
      }.to change{Rating.count}.from(2).to(1)
      expect(page).to have_content user.username
      expect(page).to have_content "Has made 0 rating"
      expect(page).not_to have_content "#{beer1.name}: 10"
      expect(page).not_to have_content "#{beer2.name}: 20"
    end

    it "user has favourite beer" do
      visit user_path(user)

      expect(page).to have_content "Favorite style: #{beer1.style}"
    end

    it "user has favourite beer" do
      visit user_path(user)

      expect(page).to have_content "Favorite brewery: #{beer1.brewery.name}"
    end
  end

  it "user does not have favourite style if no ratings made" do
    visit user_path(user)

    expect(page).not_to have_content "Favorite style"
  end

  it "user does not have favourite brewery if no ratings made" do
    visit user_path(user)

    expect(page).not_to have_content "Favorite brewery"
  end
end

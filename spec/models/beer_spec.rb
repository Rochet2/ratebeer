require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:style){ FactoryGirl.create(:style) }

  it "is saved when created with proper name and style" do
    beer = Beer.create name:"Talon olut", style: style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  it "is not saved when name is missing on creation" do
    beer = Beer.create style: style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  it "is not saved when style is missing on creation" do
    beer = Beer.create name:"Talon olut"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end

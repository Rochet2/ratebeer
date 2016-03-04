require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it "beers are ordered by name by default", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    beerlist = [@beer1, @beer2, @beer3]
    expected_order = beerlist.sort_by(&:name)
    tr_elems = page.all('tr')
    for i in 1..beerlist.length do
      expect(tr_elems[i].text).to have_content expected_order[i-1].name
    end
  end

  it "beers are ordered by style when style head column clicked", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    beerlist = [@beer1, @beer2, @beer3]
    expected_order = beerlist.sort_by(&:style)
    click_link('style')
    tr_elems = page.all('tr')
    for i in 1..beerlist.length do
      expect(tr_elems[i].text).to have_content expected_order[i-1].name
    end
  end

  it "beers are ordered by brewery when brewery head column clicked", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    beerlist = [@beer1, @beer2, @beer3]
    expected_order = beerlist.sort_by{ |b| b.brewery.name }
    click_link('brewery')
    tr_elems = page.all('tr')
    for i in 1..beerlist.length do
      expect(tr_elems[i].text).to have_content expected_order[i-1].name
    end
  end
end

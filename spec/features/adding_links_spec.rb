require 'spec_helper'

feature "User adds a new link" do 
    scenario "when browsing the homepage" do 
      expect(Link.count).to eq(0)
      visit '/'
      add_link("http://www.makersacademy.com","MakersAcademy")
      expect(Link.count).to eq(1)
      link = Link.first
      expect(link.url).to eq("http://www.makersacademy.com")
      expect(link.title).to eq("MakersAcademy")
    end

    scenario "with few tags" do 
      visit "/"
      add_link("http://www.makersacademy.com",
               "MakersAcademy",
               ['education','ruby'])
      link = Link.first
      expect(link.tags.map(&:text)).to include("education")
      expect(link.tags.map(&:text)).to include("ruby")
    end



    def add_link(url,title,tags=[])  #behaviour for the page 
      within("#new-link") do   #new_link element in the form and submited 
        fill_in 'url', :with => url
        fill_in 'title', :with => title
        #tags seperated with spaces
        fill_in 'tags', :with => tags.join(' ')
        click_button 'Add link'
      end
    end

end
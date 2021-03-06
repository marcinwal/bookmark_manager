require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature "User signs in" do 



  before(:each) do 
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "with correct credentials" do 
    visit '/'

    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com','test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do 
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com','wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

  # def sign_in(email, password)
  #   visit '/sessions/new'
  #   #save_and_open_page      SAVE IN M
  #   fill_in :email, :with => email
  #   fill_in :password, :with => password
  #   click_button 'Sign in'
  # end

end

feature "User signs up" do 
  scenario "when being a new user visitng the site" do 
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq("alice@example.com")
  end

  scenario "with a password that does not match " do 
    expect{ sign_up('a@a.com','pass','wrong')}.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect{ sign_up }.to change(User, :count).by(0)
    expect(page).to have_content("This email is already taken") 
  end

  # def sign_up(email = "alice@example.com",
  #             password = "oranges!",
  #             password_confirmation ="oranges!")

  #     visit '/user/new'
  #     expect(page.status_code).to eq(200)
  #     fill_in :email, :with => email
  #     fill_in :password, :with => password
  #     fill_in :password_confirmation, :with => password_confirmation
  #     click_button "Sign up"
  # end 

end

feature 'User signs out ' do 
  before(:each) do 
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end  

  include SessionHelpers

  scenario 'while being signed in' do 
    sign_in('test@test.com','test')
    click_button "Sign out"
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welocme, test@test.com")
  end
end

feature 'user forgets the password' do 


  scenario 'user can forget the password' do 
    visit '/users/request'
    fill_request_form("test@test.com")
    expect(page).to have_content("Password recovery!")
  end

  scenario 'after the form input user should get token' do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test') 
    visit '/users/request'
    fill_request_form("test@test.com")
    click_button "request"
    expect(page).to have_content("Token has been sent to you!")
  end

  scenario "no token for unregistered user" do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test') 
    visit '/users/request'
    fill_request_form("aaa@aaa.aaa")
    click_button "request"
    expect(page).to have_content("No such user recorded")
  end

  def fill_request_form(email)
    fill_in :email, :with => email
  end
end  
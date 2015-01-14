require 'sinatra'
require 'sinatra/base'
require 'data_mapper'
require './lib/user'
require './lib/tag'
require './lib/link'
require 'rack-flash'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'      #loading DB helper 


env = ENV["RACK_ENV"] || 'development'

#defining which database datamapper should use

#DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

#require_relative ‘./models/link'


#after declaring models you should finalize them

#DataMapper.finalize

#database does not exist yet;we need to create it with ..
#DataMapper.auto_upgrade!





class BookmarkManager < Sinatra::Base

enable :sessions
set :sessions_secret, 'super secret' 
use Rack::Flash  #using flash
use Rack::MethodOverride

  
include ApplicationHelper

# helpers do
#   def current_user    
#     @current_user ||= User.get(session[:user_id]) if session[:user_id]
#   end
# end  

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map do |tag|
    #finding a tag or creating a new one if not there
    Tag.first_or_create(:text => tag)
  end
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

get '/' do
  @links = Link.all     #queryin DB for all the links
  erb :index
end

get '/tags/:text' do 
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/user/new' do 
  @user = User.new
  erb :"users/new"
end

post '/users' do 
  @user = User.create(:email => params[:email],
              :password => params[:password],
              :password_confirmation => params[:password_confirmation])
  if @user.save #if valid we save and move to the main directory
    session[:user_id] = @user.id
    redirect to('/')
  else  #if not valid we stay where we were
    #flash[:notice] = "Sorry, your passwords don't match"
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end  
end

get '/sessions/new' do 
  erb :"sessions/new"
end

post '/sessions' do 
  email, password = params[:email], params[:password]
  user = User.authenticate(email,password)
  if user
    session[:user_id] = user.id
    redirect to('/')
  else
    flash[:errors] = ["The email or password is incorrect"]
    erb :"sessions/new"
  end
end

delete '/sessions' do
  session[:user_id] = nil
  #erb :good_bye
  flash[:notice] = "Good bye!"
  # sleep 3
  # erb :index
end
end
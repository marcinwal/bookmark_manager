require 'sinatra'
require 'data_mapper'

env = ENV["RACK_ENV"] || 'development'

#defining which database datamapper should use

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link' # this needs to be done after datamapper is initialised


#after declaring models you should finalize them

DataMapper.finalize

#database does not exist yet;we need to create it with ..
DataMapper.auto_upgrade!

get '/' do
  erb :index
end
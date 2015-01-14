require 'sinatra'
require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'
require_relative 'models/user'
require_relative 'models/tag'
require_relative 'models/link'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'      #loading DB helper 

require_relative 'controllers/links'
require_relative 'controllers/application'
require_relative 'controllers/sessions'
require_relative 'controllers/tags'
require_relative 'controllers/users'


set :partial_template_engine, :erb

env = ENV["RACK_ENV"] || 'development'

#defining which database datamapper should use

#DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

#require_relative ‘./models/link'


#after declaring models you should finalize them

#DataMapper.finalize

#database does not exist yet;we need to create it with ..
#DataMapper.auto_upgrade!





# class BookmarkManager < Sinatra::Base

enable :sessions
set :sessions_secret, 'super secret' 
use Rack::Flash  #using flash
use Rack::MethodOverride

  
include ApplicationHelper









# end
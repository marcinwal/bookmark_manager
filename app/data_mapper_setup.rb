env = ENV["RACK_ENV"] || 'development'

#defining which database datamapper should use

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

#require_relative ‘./models/link'


#after declaring models you should finalize them

DataMapper.finalize

#database does not exist yet;we need to create it with ..
DataMapper.auto_upgrade!

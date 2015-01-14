#class which corresponds to the table
#we will use it to manipulate the data

class Link
  #this makes the instances of this class Datamapper 
  include DataMapper::Resource
  #this block describes the model
  property :id, Serial
  property :title, String
  property :url, String
  has n, :tags, :through => Resource
end
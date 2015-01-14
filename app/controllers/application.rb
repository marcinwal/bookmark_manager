get '/' do
  @links = Link.all     #queryin DB for all the links
  erb :index
end
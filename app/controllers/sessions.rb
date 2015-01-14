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
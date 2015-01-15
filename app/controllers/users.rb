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


get '/users/reset_password/:token' do

end



get '/users/request' do 
  erb :request
end

post '/request' do
  email = params[:email]
  puts email
  user = User.first(:email => email)
  if user
    token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token = token
    user.password_token_timestamp = Time.now
    user.save
    flash[:notice] = "Token has been sent to you!"
  else
    flash[:notice] = "No such user recorded"
  end  
  #send the email !!!!!!!!
  redirect to('/')
end


get '/users/reset_password/:token' do 
   user = User.first(:password_token => token)
   time_issued = user.password_token_timestamp
   if (Time.now - time_issued >3600) #too late
      flash[:notice] = "Token expired"
      user.password_token = nil
      user.password_token_timestamp = nil
      redirect to('/')
   else
      redirect "/users/reset_password/#{token}", 307 #post
   end 
end



post '/users/reset_password' do 
  @user = User.first(:token => token)
  erb :"users/password"
end

post '/users/password_reset_final' do 
  password = params[:password]
  password_confirmation = params[:password_confirmation]
  @user.password = password
  @user.password_confirmation = password_confirmation
  @user.password_token = nil
  @user.password_token_timestamp = nil
  @user.save
  flash[:notce] = "Password reseted!"
  redirect '/'
end

module ApplicationHelper
  def current_user    
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end


  def send_simple_message(from,to,subject,text)
    RestClient.post "https://api:key-d79646200fd6e9ffd765c633589d5df8"\
    "@api.mailgun.net/v2/sandbox4418aa7e3d6146a5baab3ba1fa28db4c.mailgun.org/messages",
    :from => from,
    :to => to,
    :subject => subject,
    :text => text
  end

end
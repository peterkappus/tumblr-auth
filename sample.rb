require './tumblr_auth.rb'
client = TumblrAuth::get_authenticated_client
puts client.info
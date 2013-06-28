module TumblrAuth

  require 'oauth'
  require 'tumblr_client'
  require 'yaml'

  def self.get_authenticated_client
    #load the config hash from our config yaml file
    config = YAML::load_file("config.yaml")

    #does our config already contain an oauth_token?
    if(config['oauth_token'].to_s.empty?)
      consumer = OAuth::Consumer.new( config['consumer_key'], config['consumer_secret'], {
        :site               => "http://www.tumblr.com",
        :scheme             => :header,
        :http_method        => :post,
        :request_token_path => "/oauth/request_token",
        :access_token_path  => "/oauth/access_token",
        :authorize_path     => "/oauth/authorize"
        })

      # Leg 1: get the request token
      # https://groups.google.com/forum/?fromgroups#!topic/tumblr-api/foJZZdSKO2s
      #request_token = consumer.get_request_token(:exclude_callback => true)
      request_token = consumer.get_request_token(:oauth_callback => "http://localhost")

      # Leg 2: pasting this in url and getting oauth_verifier
      puts "Open this URL in your browser and allow access."
      puts request_token.authorize_url

      # Leg 3 : Get oauth token & secret
      puts "Paste the resulting 'oauth_verifier' from the query string below:"
      access_token = request_token.get_access_token({:oauth_verifier =>gets.chomp})

      #Assign to values in our config hash
      config['oauth_token'] = access_token.token
      config['oauth_token_secret'] = access_token.secret  

      puts "Saving oauth values to config file..."    
      IO.write("config.yaml",config.to_yaml)
    end

    #now configure our tumblr gem with our values
    Tumblr.configure do |conf|
      conf.consumer_key = config['consumer_key']
      conf.consumer_secret = config['consumer_secret']
      conf.oauth_token = config['oauth_token']
      conf.oauth_token_secret = config['oauth_token_secret']
    end

    #instantiate the client
    Tumblr.new
  end


  #verify that it worked
  #puts client.info
  #client.photo(blog_url,{:data=>['./path.jpg'], :tags=>'comma,separated,tags,go,here'})
end

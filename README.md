tumblr-auth
===========

Easily create an oauth-authenticated tumblr client.

## Overview
	This module makes it easy to complete the 3-legged oauth process from the command line. It walks you through getting your oauth token & secret, writes them to a config file for later use, and gives you an authenticated Tumblr client to use. It uses the excellent "tumblr_client" gem so please refer to its documentation for more on what you can do with it.

## Installation
	Install the necessary gems:
	%> bundle install

	Create the config file (using the sample):
	%> cp config.sample.yaml config.yaml

	NOTE: Make sure you're config file is writable by you (or your app) so that it can store the oauth token & secret for you. 

	Go to http://www.tumblr.com/oauth/apps to get the consumer key & consumer secret for your app.
	Plug these values into the config.yaml file

	Finito.
	
## Usage
	See "sample.rb" for a sample app.

		#require the module-file
		require './tumblr_auth.rb'
	
		#create a new client using the module's "get_authenticated_client" method
		client = TumblrAuth::get_authenticated_client
	
		#do something with it...
		puts client.info
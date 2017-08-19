class HomeController < ApplicationController
  def index
    RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
    @spotify_access_token = RSpotify.instance_variable_get("@client_token")
  end
end

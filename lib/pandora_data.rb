require 'pandata'
require 'pandora_likes'

class PandoraData
  attr_accessor :id, :user, :scraper

  def initialize(id)
    @id = id
  end

  # Returns true if successful.
  # Must be called before anything else.
  def get_scraper
    self.scraper = Pandata::Scraper.get(id)
    !scraper.kind_of? Array
  end

  def get_liked_tracks
    PandoraLikes.new(scraper).get_likes_for(user)
  end

  def get_bookmarked_tracks
    scraper.bookmarks(:tracks)
  end

  private

  def user
    @user ||= User.find_or_create_by(pandora_id: id)
  end
end

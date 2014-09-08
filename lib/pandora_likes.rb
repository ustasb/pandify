require 'pandata'

class PandoraLikes
  attr_accessor :scraper

  # When 3 downloaded tracks match the user's latest 3 liked tracks, the user's
  # Pandora data is in sync.
  MATCHES_TO_FIND = 3

  def initialize(scraper)
    @scraper = scraper
  end

  def get_likes_for(user)
    if user.latest_3_liked_tracks.nil?
      get_tracks_for_user(user) # Get tracks for the first time.
    else
      update_tracks_for(user)
    end

    present_tracks(user)
  end

  private

  def update_tracks_for(user)
    latest_3_tracks = get_latest_3_tracks
    users_latest_3_tracks = user.latest_3_liked_tracks

    return if latest_3_tracks == users_latest_3_tracks

    match_count = 0
    new_tracks_count = 0

    scraper.download_cb = -> (track_batch) {
      track_batch.each do |track|
        if track.stringify_keys == users_latest_3_tracks[match_count]
          match_count += 1
        else
          new_tracks_count += 1 + match_count
          match_count = 0
        end

        return :stop if match_count == MATCHES_TO_FIND
      end
    }

    likes = scraper.likes(:tracks)
    scraper.download_cb = nil

    if match_count == MATCHES_TO_FIND
      likes = likes.first(new_tracks_count)
    end

    add_tracks_to_user(likes, user)
    user.update_attribute(:latest_3_liked_tracks, latest_3_tracks)
  end

  def get_tracks_for_user(user)
    likes = scraper.likes(:tracks)
    add_tracks_to_user(likes, user)
    user.update_attribute(:latest_3_liked_tracks, likes.first(3))
  end


  def present_tracks(user)
    user.tracks.map do |track|
      { track: track[:name], artist: track[:artist] }
    end
  end

  def add_tracks_to_user(tracks, user)
    tracks.each do |track|
      track = Track.find_or_create_by(name: track[:track], artist: track[:artist])
      user.tracks << track unless user.tracks.include?(track)
    end
  end

  def get_latest_3_tracks
    scraper.download_cb = -> (track_batch) { :stop }
    likes = scraper.likes(:tracks).first(3)
    scraper.download_cb = nil
    likes.map(&:stringify_keys)
  end
end

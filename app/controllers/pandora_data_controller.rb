require 'pandora_data'

class PandoraDataController < ApplicationController
  def index
    pandora_data = PandoraData.new(params[:pandora_id])
    json = {}

    unless pandora_data.get_scraper
      return render json: json, status: :not_found
    end

    # Not guaranteed to be unique. Likes and bookmarks might overlap.
    json[:tracks] = []

    if params[:liked_tracks] == 'true'
      json[:tracks].concat(pandora_data.get_liked_tracks)
    end

    if params[:bookmarked_tracks] == 'true'
      json[:tracks].concat(pandora_data.get_bookmarked_tracks)
    end

    json[:pandora_id] = params[:pandora_id]
    json[:tracks_count] = json[:tracks].count

    render json: json
  end
end

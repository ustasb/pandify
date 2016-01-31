require 'pandora_data'

class PandoraDataController < ApplicationController
  def index
    pandora_data = PandoraData.new(params[:pandora_id])
    json = {}

    unless pandora_data.get_scraper
      return render json: json, status: :not_found
    end

    json[:pandora_id] = params[:pandora_id]
    json[:tracks] = pandora_data.get_liked_tracks
    json[:tracks_count] = json[:tracks].count

    render json: json
  end
end

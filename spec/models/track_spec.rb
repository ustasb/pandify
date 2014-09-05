require 'rails_helper'

describe Track do

  context "duplicate track name and artist" do
    let(:name) { 'Porcelain' }
    let(:artist) { 'Moby' }

    it "doesn't store duplicate tracks" do
      a = Track.create name: name, artist: artist
      b = Track.create name: name, artist: artist
      expect(a == b)
      expect(Track.all.size).to be 1
    end
  end

end

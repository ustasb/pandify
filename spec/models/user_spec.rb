require 'rails_helper'

describe User do

  context "duplicate user pandora_id" do
    let(:pandora_id) { 'bjjustas' }

    it "doesn't store duplicate users" do
      a = User.create pandora_id: pandora_id
      b = User.create pandora_id: pandora_id
      expect(a == b)
      expect(User.all.size).to be 1
    end
  end

  context "duplicate tracks" do
    let(:track1) { Track.create name: 'Porcelain', artist: 'Moby' }
    let(:track2) { Track.create name: 'Porcelain', artist: 'Marianas Trench' }
    let(:user) { User.create pandora_id: 'bjjustas' }

    it "doesn't store duplicate tracks and raises an error" do
      user.tracks.concat track1
      expect { user.tracks.concat track1 }.to raise_error ActiveRecord::RecordNotUnique
      expect(user.tracks.size).to be 1
      expect { user.tracks.concat track2 }.to_not raise_error
      expect(user.tracks.size).to be 2
    end
  end

end

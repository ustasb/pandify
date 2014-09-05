class CreateTracksUsers < ActiveRecord::Migration
  def change
    create_table :tracks_users, id: false do |t|
      t.belongs_to :track
      t.belongs_to :user
    end

    add_index :tracks_users, [:track_id, :user_id], unique: true
  end
end

class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :artist

      t.timestamps
    end

    add_index :tracks, [:name, :artist], unique: true
  end
end

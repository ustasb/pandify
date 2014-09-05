class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :pandora_id
      t.json :latest_3_liked_tracks

      t.timestamps
    end

    add_index :users, :pandora_id, unique: true
  end
end

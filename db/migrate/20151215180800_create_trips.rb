class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :location
      t.float :latitude
      t.float :longitude
      t.date :start_date
      t.integer :days, default: 1
      t.string :session_id
      t.timestamps
    end
  end
end

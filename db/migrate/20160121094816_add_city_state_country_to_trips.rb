class AddCityStateCountryToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :city, :string
    add_column :trips, :state, :string
    add_column :trips, :country, :string
  end
end

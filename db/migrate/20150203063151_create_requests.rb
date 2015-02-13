class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :destination
      t.date   :arrival
      t.date   :departure
      t.string :companions
      t.string :budget
      t.string :trip_type
      t.text   :details
      t.string :first_name
      t.string :email
      t.timestamps
    end
  end
end

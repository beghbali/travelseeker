class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.string :uri
      t.string :session_id
      t.timestamps
    end
  end
end

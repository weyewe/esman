class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :name
      t.text :address
      t.integer :home_type_id
      t.timestamps
    end
  end
end

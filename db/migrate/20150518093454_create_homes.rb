class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :name
      t.text :address
      t.integer :home_type_id
      t.datetime :deleted_at 
      t.boolean :is_deleted, :default => false 
      t.timestamps
    end
  end
end

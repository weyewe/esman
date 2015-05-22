class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.text   :address
      t.text   :description
      t.datetime :deleted_at 
      t.boolean :is_deleted, :default => false 
      t.timestamps
    end
  end
end

class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.text   :address
      t.text   :description
      t.timestamps
    end
  end
end

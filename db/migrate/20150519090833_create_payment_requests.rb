class CreatePaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requests do |t|
      t.integer :vendor_id
      t.datetime :request_date
      t.string :code    
      t.text :description 
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.boolean :is_deleted , :default => false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end

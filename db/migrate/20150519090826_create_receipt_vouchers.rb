class CreateReceiptVouchers < ActiveRecord::Migration
  def change
    create_table :receipt_vouchers do |t|
        t.string :code 
        t.text :description
        t.integer :user_id
        t.integer :receivable_id
        t.integer :cash_bank_id
        t.datetime :receipt_date
        t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 
        t.boolean :is_confirmed , :default => false
        t.datetime :confirmed_at 
        t.boolean :is_deleted ,:default => false
        t.datetime :deleted_at
        
        t.timestamps
    end
  end
end

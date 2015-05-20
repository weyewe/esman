class CreateCashBankAdjustments < ActiveRecord::Migration
  def change
    create_table :cash_bank_adjustments do |t|
      t.integer :cash_bank_id
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      
      t.integer :status , :default        => ADJUSTMENT_STATUS[:addition]
      
      t.datetime :adjustment_date 
      
      t.datetime :confirmed_at 
      t.boolean :is_confirmed, :default => false 
      t.datetime :deleted_at 
      t.boolean :is_deleted, :default => false 
      t.text :description
      t.string :code 

      t.timestamps
    end
  end
end

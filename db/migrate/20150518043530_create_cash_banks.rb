class CreateCashBanks < ActiveRecord::Migration
  def change
    create_table :cash_banks do |t|
      t.string :name
      t.text :description
      t.boolean :is_bank, :default => true  
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 
      t.datetime :deleted_at 
      t.boolean :is_deleted, :default => false 
      t.timestamps
    end
  end
end

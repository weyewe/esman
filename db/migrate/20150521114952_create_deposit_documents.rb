class CreateDepositDocuments < ActiveRecord::Migration
  def change
    create_table :deposit_documents do |t|
        t.string :code 
        t.text :description
        t.integer :user_id
        t.integer :home_id
        t.datetime :deposit_date
        t.decimal :amount_deposit , :default        => 0,  :precision => 14, :scale => 2 
        t.decimal :amount_charge , :default        => 0,  :precision => 14, :scale => 2 
        t.boolean :is_confirmed , :default => false
        t.datetime :confirmed_at 
        t.boolean :is_finished , :default => false
        t.datetime :finished_at 
        t.boolean :is_deleted ,:default => false
        t.datetime :deleted_at
      t.timestamps
    end
  end
end

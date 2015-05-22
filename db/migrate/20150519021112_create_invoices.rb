class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :source_id
      t.string :source_class
      t.string :source_code
      t.string :code
      t.integer :home_id 
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.datetime :due_date 
      t.datetime :invoice_date 
      t.text :description
      t.boolean :is_confirmed , :default =>false
      t.datetime :confirmed_at
      t.boolean :is_deleted , :default =>false
      t.datetime :deleted_at

      t.boolean :is_paid , :default => false 
      t.datetime :paid_at  

      t.timestamps
    end
  end
end

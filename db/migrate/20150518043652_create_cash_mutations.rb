class CreateCashMutations < ActiveRecord::Migration
  def change
    create_table :cash_mutations do |t|
      t.string :source_class
      t.integer :source_id 
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 
      t.integer :status , :default        => ADJUSTMENT_STATUS[:addition] 
      t.datetime :mutation_date 
      t.integer :cash_bank_id 

      t.timestamps
    end
  end
end

class CreateMonthlyGenerators < ActiveRecord::Migration
  def change
    create_table :monthly_generators do |t|
      t.datetime :generated_date
      t.string :code
      t.text :description
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at 
      t.boolean :is_deleted ,:default => false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end

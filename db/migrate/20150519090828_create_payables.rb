class CreatePayables < ActiveRecord::Migration
  def change
    create_table :payables do |t|
      t.string  :source_class
      t.integer :source_id
      t.string  :source_code
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :remaining_amount , :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_deleted ,:default   => false
      t.datetime :deleted_at
      t.timestamps
      t.timestamps
    end
  end
end

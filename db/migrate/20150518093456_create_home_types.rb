class CreateHomeTypes < ActiveRecord::Migration
  def change
    create_table :home_types do |t|
      t.string  :name
      t.text    :description
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.datetime :deleted_at 
      t.boolean :is_deleted, :default => false 
      t.timestamps
    end
  end
end

class CreateHomeTypes < ActiveRecord::Migration
  def change
    create_table :home_types do |t|
      t.string  :name
      t.text    :description
      t.timestamps
    end
  end
end

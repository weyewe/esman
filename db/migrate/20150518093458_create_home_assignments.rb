class CreateHomeAssignments < ActiveRecord::Migration
  def change
    create_table :home_assignments do |t|
      t.integer :user_id
      t.integer :home_id
      t.boolean :is_deleted ,:default => false
      t.datetime :deleted_at
      t.datetime :assignment_date
      t.timestamps
    end
  end
end

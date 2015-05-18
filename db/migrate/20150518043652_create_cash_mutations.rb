class CreateCashMutations < ActiveRecord::Migration
  def change
    create_table :cash_mutations do |t|

      t.timestamps
    end
  end
end

class CreateCashBankMutations < ActiveRecord::Migration
  def change
    create_table :cash_bank_mutations do |t|

      t.timestamps
    end
  end
end

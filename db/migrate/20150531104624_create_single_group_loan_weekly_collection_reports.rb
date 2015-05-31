class CreateSingleGroupLoanWeeklyCollectionReports < ActiveRecord::Migration
  def change
    create_table :single_group_loan_weekly_collection_reports do |t|
    	t.integer :group_loan_weekly_collection_id 
    	t.boolean :is_finished, :default => false 
      t.datetime :finished_at 
    	
    	t.string :return_url 
    	t.string :stored_result_url  # in s3,drobox? 

      t.timestamps
    end
  end
end

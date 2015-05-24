class GroupLoanWeeklyCollectionReportsController < ApplicationController
	# include AbstractController::Rendering
	# # include AbstractController::Layouts
	# include AbstractController::Helpers
	# include AbstractController::Translation
	# include AbstractController::AssetPaths  
	# # helper InvoicesHelper
	# self.view_paths = "app/views"
	def banzai
		@collection_week_number =15
		html = render_to_string template: "group_loan_weekly_collection_reports/new" , layout: "pdf"
		# puts 
		return html
	end

	def print(params_id)
		# @object = GroupLoanWeeklyCollectionReport.find_by_id params_id

		# @objects  = @object.extract_details_from_server
		@collection_week_number = params_id
	
		html = render_to_string template: "group_loan_weekly_collection_reports/print" , layout: "pdf"
		# puts 
		return html

		# render layout: "basic", template: "group_loan_weekly_collection_reports/print.html.erb"
	end
end

=begin
first_report = GroupLoanWeeklyCollectionReport.order("id ASC").first
html = GroupLoanWeeklyCollectionReportsController.new.print( first_report.id ) 

 GroupLoanWeeklyCollectionReportsController.new.new 

 a = GroupLoanWeeklyCollectionReportsController.new
 html = a.print( 5 )

 pdf = WickedPdf.new.pdf_from_string(html,{
  orientation:  'Landscape'
 })
 File.open("#{Rails.root}/meong_oo.pdf", 'wb') do |file|
  file << pdf
 end
=end
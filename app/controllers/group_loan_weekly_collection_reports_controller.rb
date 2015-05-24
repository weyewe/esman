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

	def print(id)
		response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
			{ 
			  :body => {
			    :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
			  }
		})

		server_response =  JSON.parse(response.body )

		auth_token  = server_response["auth_token"]

		response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/group_loan_weekly_collection_reports/#{id}" ,
		  :query => {
		    :auth_token => auth_token
		})

		server_response =  JSON.parse(response.body )
		@local_now = DateTime.now + 7.hours
		@week_number = server_response["week_number"] 
		@confirmed_at = server_response["confirmed_at"].to_datetime + 7.hours 
		@group_loan_name = server_response["group_loan_name"]
		@group_loan_group_number  = server_response["group_loan_group_number"]

		@objects = server_response["group_loan_weekly_collection_report_details"]
 
	
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
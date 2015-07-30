require 'dropbox_sdk'
require 'fileutils'
require "pdf/merger"
require 'rjb'
require 'httparty'
require 'json'




class SingleGroupLoanWeeklyCollectionReport < ActiveRecord::Base
	validates_presence_of :group_loan_weekly_collection_id
	validates_presence_of :return_url 

	def self.create_object( params )
		new_object = self.new 
		new_object.group_loan_weekly_collection_id = params[:group_loan_weekly_collection_id]
		new_object.return_url = params[:return_url]



		if new_object.save

			new_object.delay.generate_report_and_report_back

			# @user.delay.activate!(@device)
		end

		return new_object
	end




	def generate_report_and_report_back
		local_result_location = self.class.generate_report( 
							self.group_loan_weekly_collection_id,
							"result_pdf_name",
							"/folder/location" )

		# upload to dropbox 

		dropbox_upload_result_url  = self.class.upload_to_dropbox( 
						local_result_location,
						dropbox_path,
						dropbox_filename )

		





		self.stored_result_url = dropbox_upload_result_url #result["url"]
		self.is_finished = true 
		self.finished_at = DateTime.now 
		self.save 

		# update the main server

		self.class.notify_core_server( self  )


	end


	def self.get_auth_token
		response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
			{ 
			  :body => {
			    :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
			  }
		})

		server_response =  JSON.parse(response.body )

		auth_token  = server_response["auth_token"]

		return auth_token 
	end



	def self.notify_core_server( report_generator ) 


		response = HTTParty.put( report_generator.return_url  ,
	    { 
			:query => {
      			:auth_token => self.get_auth_token,
      			:result_url => report_generator.stored_result_url
      		}

	    })

	end

	def self.upload_to_dropbox( result_pdf , dropbox_path, result_filename  )
		client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)

		file = open( result_pdf )

		dropbox_file_location  = "#{dropbox_path}/#{result_filename}"
		dropbox_upload_result = client.put_file(dropbox_file_location, file)

		# get the sharable url
		result =  client.shares( dropbox_upload_result["path"] )

		return result["url"]
	end

=begin 
SingleGroupLoanWeeklyCollectionReport.generate_report( 48841 "awesome.pdf", "hah")
=end
	# will return the  report location in the server folder
	def self.generate_report( weekly_collection_id, result_pdf_name , folder_location  )

		puts "The id we are printing: #{weekly_collection_id}"
		temporary_folder = "#{folder_location}/temporary"
		member_filename = "member_filename.pdf"
		kki_filename = "kki_filename.pdf"



	    temporary_report_folder = "#{temporary_folder}/#{weekly_collection_id}"

	    unless File.directory?(temporary_report_folder)
	      FileUtils.mkdir_p(temporary_report_folder)
	    end

	    member_pdf_path   = "#{temporary_report_folder}/#{member_filename}"
	    kki_pdf_path = "#{temporary_report_folder}/#{kki_filename}"
	    result_pdf_path = "#{temporary_report_folder}/#{result_pdf_name}"


		a = GroupLoanWeeklyCollectionReportsController.new
	    html = a.print( weekly_collection_id )

	    WickedPdf.config = {
		    exe_path:  WKHTMLTOPDF_EXE_PATH
		  }

	    pdf = WickedPdf.new.pdf_from_string(html,{
	     orientation:  'Landscape',
	     :page_size => "Letter"
	    })

	    File.open(member_pdf_path, 'wb') do |file|
	      file << pdf
	    end

	    File.open(kki_pdf_path, 'wb') do |file|
	      file << pdf
	    end


		puts "merging all result folder"
		failure_list = []
		pdf = PDF::Merger.new

		pdf.add_file member_pdf_path
		pdf.add_file kki_pdf_path

		pdf.add_javascript "this.print(true);"
		pdf.save_as result_pdf_path , failure_list

		# delete the temporary pdf file 
		File.delete( member_pdf_path )
		File.delete( kki_pdf_path )

		return result_pdf_path 
	end
end

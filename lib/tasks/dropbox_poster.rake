require 'dropbox_sdk'
require 'fileutils'
require "pdf/merger"
require 'rjb'
require 'httparty'
require 'json'


=begin
  
  for sikki: user send the local time 
    2015-5-12 00:00 

    Server save it as  UTC 
    2015-5-11 17:00

    When user wants to query, the user will query with local time

    example: give me data in 12 May 2015
    start_datetime : 2015-5-11 17:00
    end_datetime   : 2015-5-12 16:59

    so, if today's utc

  today_kki_date = DateTime.now.in_time_zone 'Jakarta'
  report_disbursement_date = today_kki_date  + 2.days
  last_week_report_data = report_disbursement_date - 1.weeks
  start_datetime = last_week_report_data.beginning_of_day.utc
  end_datetime =  last_week_report_data.end_of_day.utc

  
=end

task :post_to_dropbox => :environment do
  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)



  filename = DateTime.now.to_s
  file_location = "#{PDF_FILE_LOCATION}/#{filename}.txt"
  File.open( file_location , 'w') {|f| f.write("write your stuff here") }

  file = open( file_location )

  dropbox_file_location  = "/willy/#{filename}.txt"
  client.put_file(dropbox_file_location, file)

    
end

task :local_report => :environment do
  # get the ID to be printed

  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]

  response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/group_loan_weekly_collection_reports" ,
    :query => {
      :auth_token => auth_token,
      :starting_datetime =>  "2015-05-19T07:00:00+00:00",
      :ending_datetime => "2015-05-20T06:59:59+00:00"
    })

  server_response =  JSON.parse(response.body )

  id = server_response["group_loan_weekly_collection_reports"].first["id"]



  WickedPdf.config = {
    exe_path:  '/usr/bin/wkhtmltopdf'
  }

  a = GroupLoanWeeklyCollectionReportsController.new
  html = a.print( id ) # calling method print

  pdf = WickedPdf.new.pdf_from_string(html,{
   orientation:  'Landscape',
   :page_size => "Letter"
  })

  File.open("#{Rails.root}/awesome/file.pdf", 'wb') do |file|
    file << pdf
  end

end 

task :generate_weekly_collection_report_for_tomorrow_and_post_to_dropbox => :environment do
  # get auth_token

  today_kki_date = DateTime.now.in_time_zone 'Jakarta'
  weekly_collection_report_disburse_day = today_kki_date  + 2.days
  last_week_report_data = weekly_collection_report_disburse_day - 1.weeks
  beginning_of_day = last_week_report_data.beginning_of_day.utc
  end_of_day =  last_week_report_data.end_of_day.utc

 
  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]
  puts "auth_token = #{auth_token}"

  # get all id to be printed
  response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/group_loan_weekly_collection_reports" ,
    :query => {
      :auth_token => auth_token,
      # :starting_datetime =>  "2015-05-18T07:00:00+00:00",
      # :ending_datetime => "2015-05-19T06:59:59+00:00"
      :starting_datetime =>  beginning_of_day , # "2015-05-20T07:00:00+00:00",
      :ending_datetime => end_of_day  # "2015-05-21T06:59:59+00:00"
    })

  server_response =  JSON.parse(response.body )


  id_list = []
  # counter = 0 
  server_response["group_loan_weekly_collection_reports"].each do |row|
    # break if counter == 5
    id_list << row["id"]
    # counter = counter + 1
  end

  puts "total : #{id_list.size}"
  puts "id_list: #{id_list}"


  folder_location = "#{PDF_FILE_LOCATION}/tomorrow_date"
  temporary_folder = "#{folder_location}/temporary"
  member_filename = "member_filename.pdf"
  kki_filename = "kki_filename.pdf"



  year = weekly_collection_report_disburse_day.year
  month = weekly_collection_report_disburse_day.month
  day = weekly_collection_report_disburse_day.day 

  result_filename = "" + year.to_s + "_"
  if month.to_s.length == 1
    result_filename   = result_filename + "0#{month}" + "_"
  else
    result_filename = result_filename + month.to_s + "_"
  end

  if day.to_s.length == 1 
    result_filename = result_filename  + "0#{day}.pdf" 
  else
    result_filename = result_filename  + "#{day}.pdf" 
  end





  # result_filename   = "result.pdf"
# 2015/04/06

  temp_result_filename = "temp_result.pdf"
  result_pdf = "#{folder_location}/#{result_filename}"
  
  unless File.directory?(temporary_folder)
    FileUtils.mkdir_p(temporary_folder)
  end

  WickedPdf.config = {
    exe_path:  WKHTMLTOPDF_EXE_PATH
  }

  temp_result_array = [] 
  id_list.each do |x|
    puts "id: #{x}"

    a = GroupLoanWeeklyCollectionReportsController.new
    html = a.print( x )

    pdf = WickedPdf.new.pdf_from_string(html,{
     orientation:  'Landscape',
     :page_size => "Letter"
    })

    temporary_report_folder = "#{temporary_folder}/#{x}"
    unless File.directory?(temporary_report_folder)
      FileUtils.mkdir_p(temporary_report_folder)
    end

    member_pdf_path   = "#{temporary_report_folder}/#{member_filename}"
    kki_pdf_path = "#{temporary_report_folder}/#{kki_filename}"
    File.open(member_pdf_path, 'wb') do |file|
      file << pdf
    end

    File.open(kki_pdf_path, 'wb') do |file|
      file << pdf
    end

    temp_result_pdf = "#{folder_location}/#{x}"

    failure_list = []
    pdf = PDF::Merger.new
    pdf.add_file member_pdf_path
    pdf.add_file kki_pdf_path
    pdf.add_javascript "this.print(true);"
    pdf.save_as temp_result_pdf , failure_list
    temp_result_array << temp_result_pdf


 
  end

  puts "merging all result folder"
  failure_list = []
  pdf = PDF::Merger.new
  temp_result_array.each do |temp_result_pdf_path|
    pdf.add_file temp_result_pdf_path
  end

  pdf.add_javascript "this.print(true);"
  pdf.save_as result_pdf , failure_list



  puts "gonna send to dropbox"

  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)

  file = open( result_pdf )

  dropbox_file_location  = "/willy/#{result_filename}"
  client.put_file(dropbox_file_location, file)

  puts "deleting all temporary results"


  temp_result_array.each do |temp_result_pdf_path|
    File.delete( temp_result_pdf_path )
  end
  
  FileUtils.rm_rf( temporary_folder )

  puts "done"





  # WickedPdf.config = {
  #   exe_path:  WKHTMLTOPDF_EXE_PATH
  # }
  # a = GroupLoanWeeklyCollectionReportsController.new
  # html = a.print( 5 )

  # pdf = WickedPdf.new.pdf_from_string(html,{
  #  orientation:  'Landscape',
  #  :page_size => "Letter"
  # })

  # member_pdf_path   = "#{temporary_folder}/#{member_filename}"
  # kki_pdf_path = "#{temporary_folder}/#{kki_filename}"
  # File.open(member_pdf_path, 'wb') do |file|
  #   file << pdf
  # end

  # File.open(kki_pdf_path, 'wb') do |file|
  #   file << pdf
  # end


  # failure_list = []
  # pdf = PDF::Merger.new
  # pdf.add_file member_pdf_path
  # pdf.add_file kki_pdf_path
  # pdf.add_javascript "this.print(true);"
  # pdf.save_as result_pdf , failure_list

  # client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)

  # file = open( result_pdf )

  # dropbox_file_location  = "/willy/#{result_filename}"
  # client.put_file(dropbox_file_location, file)



end

# cd /var/www/sableng.com/current ; bundle exec rake generate_weekly_collection_report_for_tomorrow_and_post_to_dropbox



=begin
	
#to make directory
require 'fileutils'
folder_location = "#{PDF_FILE_LOCATION}/awesome_folder"
FileUtils.mkdir_p  folder_location

unless File.directory?(dirname)
  FileUtils.mkdir_p(dirname)
end

WickedPdf.config = {
  exe_path:  WKHTMLTOPDF_EXE_PATH
}

a = GroupLoanWeeklyCollectionReportsController.new
html = a.print( 5 )

pdf = WickedPdf.new.pdf_from_string(html,{
orientation:  'Landscape'
})
File.open("#{Rails.root}/meong_oo.pdf", 'wb') do |file|
file << pdf
end

=end

=begin
	
 # making pdf

  a = GroupLoanWeeklyCollectionReportsController.new
  html = a.print( 5 )

  pdf = WickedPdf.new.pdf_from_string(html,{
  orientation:  'Landscape'
  })
  File.open("#{Rails.root}/meong_oo.pdf", 'wb') do |file|
  file << pdf
  end

=end
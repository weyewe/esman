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



# /usr/local/bin/wkhtmltopdf

  WickedPdf.config = {
    exe_path:  WKHTMLTOPDF_EXE_PATH
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


def generate_report( today_kki_date )
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
  return if server_response["group_loan_weekly_collection_reports"].count == 0 

  server_response["group_loan_weekly_collection_reports"].each do |row|
    # break if counter == 5
    id_list << row["id"]
    # counter = counter + 1
  end

  puts "total : #{id_list.size}" 


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

  dropbox_file_location  = "/dummy/#{result_filename}"
  client.put_file(dropbox_file_location, file)

  puts "deleting all temporary results"


  temp_result_array.each do |temp_result_pdf_path|
    File.delete( temp_result_pdf_path )
  end
  
  FileUtils.rm_rf( temporary_folder )

  puts "done"

end



# cd /var/www/sableng.com/current ; bundle exec rake dummy_generate_weekly_collection_report_for_tomorrow_and_post_to_dropbox



def generate_report_from_id_list( id_list , result_filename, folder_location ) 
  unless File.directory?(folder_location)
    FileUtils.mkdir_p(folder_location)
  end


  # folder_location = "#{PDF_FILE_LOCATION}/tomorrow_date"
  temporary_folder = "#{folder_location}/temporary"
  member_filename = "member_filename.pdf"
  kki_filename = "kki_filename.pdf"


  result_pdf = "#{folder_location}/#{result_filename}"
  
  unless File.directory?(temporary_folder)
    FileUtils.mkdir_p(temporary_folder)
  end

  temp_result_array = [] 

  id_list.each do |x|
    report_location = SingleGroupLoanWeeklyCollectionReport.generate_report( 
      x, 
      "result.pdf" , 
      folder_location  )

    temp_result_array << report_location
  end

  puts "merging all result folder"
  failure_list = []
  pdf = PDF::Merger.new
  temp_result_array.each do |temp_result_pdf_path|
    pdf.add_file temp_result_pdf_path
  end

  pdf.add_javascript "this.print(true);"
  pdf.save_as result_pdf , failure_list






  temp_result_array.each do |temp_result_pdf_path|
    File.delete( temp_result_pdf_path )
  end

  
  FileUtils.rm_rf( temporary_folder )
  puts "done creating result pdf"
  return result_pdf 

end

def generate_weekly_collection_report_for(weekly_collection_report_disburse_day,
                                           dropbox_upload_path, local_path) 

  last_week_report_data = weekly_collection_report_disburse_day - 1.weeks
  beginning_of_day = last_week_report_data.beginning_of_day.utc
  end_of_day =  last_week_report_data.end_of_day.utc


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





  # 1. get auth token to get the weekly_collection_id_list to create report
  # 2. generate report in the local
  # 3. upload local report to dropbox
  # 4. delete local report 
  # 5. DONE 

 
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

  if server_response["group_loan_weekly_collection_reports"].count == 0 
    puts "no data from server"
     
  else
    server_response["group_loan_weekly_collection_reports"].each do |row|
      id_list << row["id"]
      puts "total : #{id_list.size}"
      puts "id_list: #{id_list}"
    end



    result_file_location = generate_report_from_id_list( 
                  id_list , 
                  result_filename,
                  "#{PDF_FILE_LOCATION}/#{local_path}"
                  )

    # upload to dropbox

    puts "gonna send to dropbox"

    client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)

    file = open( result_file_location )

    dropbox_file_location  = "#{dropbox_upload_path}/#{result_filename}"
    client.put_file(dropbox_file_location, file)

    puts "deleting all temporary results"
    File.delete( result_file_location )

    puts "done upload"

  end
end




# bundle exec rake dummy_report[3]

task :dummy_report, [:number_of_days] => :environment do | t ,args | 

  # today = DateTime.now.in_time_zone 'Jakarta'
  # (0.upto 2).each do |x|
  #   generate_report( today + x.days )
  # end
  if args.number_of_days.length == 0
    puts "the arguent must be valid"
    return 
  else
    puts "days is :#{ args.number_of_days}"
  end

  today_kki_date = DateTime.now.in_time_zone 'Jakarta'
  number_of_days = args.number_of_days.to_i
  weekly_collection_report_disburse_day = today_kki_date  + number_of_days.days

  dropbox_upload_path = "/dummy"
  local_path = "dummy_date"

  generate_weekly_collection_report_for( 
          weekly_collection_report_disburse_day ,  
            dropbox_upload_path,
            local_path)
end


task :generate_weekly_collection_report_for_tomorrow_and_post_to_dropbox => :environment do
  today_kki_date = DateTime.now.in_time_zone 'Jakarta'
  weekly_collection_report_disburse_day = today_kki_date  + 2.days
  dropbox_upload_path = "/willy"
  local_path = "tomorrow_date"

  generate_weekly_collection_report_for( 
          weekly_collection_report_disburse_day ,  
            dropbox_upload_path,
            local_path)


  # Thursday, generate one report for monday as well
  # will be printed on Friday altogether 
  if today_kki_date.wday == 4 
    generate_weekly_collection_report_for( 
              today_kki_date + 4.days, 
              dropbox_upload_path,
              local_path )
  end
end

# cd /var/www/sableng.com/current ; bundle exec rake generate_weekly_collection_report_for_tomorrow_and_post_to_dropbox



require 'dropbox_sdk'
require 'fileutils'
require "pdf/merger"

task :post_to_dropbox => :environment do
  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)



  filename = DateTime.now.to_s
  file_location = "#{PDF_FILE_LOCATION}/#{filename}.txt"
  File.open( file_location , 'w') {|f| f.write("write your stuff here") }

  file = open( file_location )

  dropbox_file_location  = "/willy/#{filename}.txt"
  client.put_file(dropbox_file_location, file)

    
end

task :generate_weekly_collection_report_for_tomorrow_and_post_to_dropbox => :environment do
  folder_location = "#{PDF_FILE_LOCATION}/tomorrow_date"
  temporary_folder = "#{folder_location}/temporary"
  member_filename = "member_filename.pdf"
  kki_filename = "kki_filename.pdf"
  result_filename   = "result.pdf"
  result_pdf = "#{folder_location}/#{result_filename}"
  unless File.directory?(dirname)
    FileUtils.mkdir_p(temporary_folder)
  end


  WickedPdf.config = {
    exe_path:  WKHTMLTOPDF_EXE_PATH
  }
  a = GroupLoanWeeklyCollectionReportsController.new
  html = a.print( 5 )

  pdf = WickedPdf.new.pdf_from_string(html,{
   orientation:  'Landscape'
  })

  member_pdf_path   = "#{temporary_folder}/#{member_filename}"
  kki_pdf_path = "#{temporary_folder}/#{kki_filename}"
  File.open(member_pdf_path, 'wb') do |file|
    file << pdf
  end

  File.open(kki_pdf_path, 'wb') do |file|
    file << pdf
  end


  failure_list = []
  pdf = PDF::Merger.new
  pdf.add_file member_pdf_path
  pdf.add_file kki_pdf_path
  pdf.add_javascript "this.print(true);"
  pdf.save_as result_pdf , failure_list

  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)
  
  file = open( result_pdf )

  dropbox_file_location  = "/willy/#{result_filename}.txt"
  client.put_file(dropbox_file_location, file)



end

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
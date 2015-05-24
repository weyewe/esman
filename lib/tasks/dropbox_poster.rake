require 'dropbox_sdk'


task :post_to_dropbox => :environment do
  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)



  filename = DateTime.now.to_s
  file_location = "#{PDF_FILE_LOCATION}/#{filename}.txt"
  File.open( file_location , 'w') {|f| f.write("write your stuff here") }

  file = open( file_location )

  dropbox_file_location  = "/willy/#{filename}.txt"
  client.put_file(dropbox_file_location, file)

    
end

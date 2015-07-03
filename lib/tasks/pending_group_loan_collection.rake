require 'dropbox_sdk'
require 'fileutils'
require 'httparty'
require 'json'


task :generate_pending_collection_report_and_post_to_dropbox => :environment do




  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]





    today_kki_date = DateTime.now.in_time_zone 'Jakarta'
    last_year = today_kki_date - 1.years
    beginning_of_last_year = last_year.beginning_of_year
    ending_of_last_year = last_year.end_of_year
    starting_datetime = beginning_of_last_year.utc 
    ending_datetime = ending_of_last_year.utc 

  today_date_string = ""
  today_date_string << today_kki_date.year.to_s  + "-"

  if today_kki_date.month.to_s.length == 1 
    today_date_string << "0"
  end
  today_date_string << today_kki_date.month.to_s + "-"

  if today_kki_date.day.to_s.length == 1 
    today_date_string << "0"
  end
  today_date_string << today_kki_date.day.to_s 





  counter = 0
  page = 1 
  limit = 50
  file_location = "/home/willy/Sites/esman/#{today_date_string}.csv" 

  CSV.open( file_location, 'w' ) do |writer| 

    header_array = [
        "Group No",
        "Nama Kelompok",
        "Disbursement Date",
        "Jumlah Anggota Aktif",
        "Jumlah Minggu Setoran",
        "Jumlah Minggu Terbayar",
        "Last Payment Date",
        "Jumlah Setoran Berikutnya"
      ]

    writer << header_array    
  end



  begin
    
    puts "in page: #{page}"
    response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/pending_group_loans" ,
        :query => {
          :auth_token => auth_token ,
          :page => page ,
          :limit => limit ,
          :starting_datetime => starting_datetime,
          :ending_datetime => ending_datetime
        })

    server_response =  JSON.parse(response.body ) 

    # puts "The server_response"

    puts server_response
 
    total_result = server_response["group_loans"].length 

    # puts "total result: #{total_result}"

    page = page + 1 

    if total_result != 0 

      CSV.open( file_location, 'a' ) do |writer| 
        

        server_response['group_loans'].each do |group_loan|
          result_array = [] 

    
          result_array << group_loan["group_number"]        
          result_array << group_loan["name"]         
          result_array << group_loan["disbursed_at"]           
          result_array << group_loan["total_active_glm"]            
          result_array << group_loan["total_weekly_collections"]            
          result_array << group_loan["total_paid_weekly_collections"]         
          result_array << group_loan["last_collection_date"]       
          result_array << group_loan["next_collection_amount"]             

          writer << result_array
        end


      
    
      end
    end

   
  end until total_result == 0


  puts "gonna put to dropbox"
  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)


  file = open( file_location )

  dropbox_file_location  = "/pending_loan_collection/#{today_date_string}.csv"
  client.put_file(dropbox_file_location, file)

  File.delete( file_location )

  
 
  

end
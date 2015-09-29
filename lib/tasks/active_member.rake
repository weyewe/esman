require 'dropbox_sdk'
require 'fileutils'
require 'httparty'
require 'json'


task :generate_active_member_report => :environment do




  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]





    today_kki_date = DateTime.now.in_time_zone 'Jakarta' 
    beginning_of_year = today_kki_date.beginning_of_year
    ending_of_year = today_kki_date.end_of_year



    starting_datetime = beginning_of_year.utc 
    ending_datetime = ending_of_year.utc 

    report_date  = today_kki_date.utc 

   





  counter = 0
  page = 1 
  limit = 50
  file_location = "#{PENDING_GROUP_LOAN_FILE_LOCATION}/active_#{today_kki_date.year.to_s}.csv" 

  CSV.open( file_location, 'w' ) do |writer| 

    header_array = [
        "Nama",
        "Member ID Number",
        "KTP",
       
        "Group Loan Name", 
        "Group Loan No",
        "Principal"
      ]

 
    writer << header_array    
  end



  begin
    
    puts "in page: #{page}"
    response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/members/active_members" ,
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
 
    total_result = server_response["active_members"].length 

    # puts "total result: #{total_result}"

    page = page + 1 

    if total_result != 0 

      CSV.open( file_location, 'a' ) do |writer| 
         

        server_response['active_members'].each do |am|
          result_array = [] 

      

              
          result_array << am["member_name"]        
          result_array << am["member_id_number"]         
          result_array << am["member_id_card_number"]           
          result_array << am["group_loan_name"]            
          result_array << am["group_loan_group_number"]   
          result_array << am["group_loan_product_principal"]                     

          writer << result_array
        end


      
    
      end
    end

   
  end until total_result == 0


  puts "gonna put to dropbox"
  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)


  file = open( file_location )

  dropbox_file_location  = "/aux_kki_report/active_member/#{today_kki_date.year.to_s}.csv"
  client.put_file(dropbox_file_location, file)

  File.delete( file_location )

  
 
  

end
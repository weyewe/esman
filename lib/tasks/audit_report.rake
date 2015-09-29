
require 'httparty'
require 'json'

FUND_TRANSFER_DIRECTION = {
  :incoming => 1,
  :outgoing => 2 
}

task :generate_audit_report => :environment do




  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]



 
 file_location = "/home/willy/Sites/esman/audit_reports.csv"
 CSV.open( file_location, 'w' ) do |writer| 
  writer << [ 
      "id_number", 
      "name",   
      "compulsory_savings_amount_by_dec_2014",   
      "voluntary_savings_amount_by_dec_2014", 
      "membership_savings_amount_by_dec_2014",    
      "locked_savings_amount_by_dec_2014"       
    ]
 end
 


  page = 1
  limit = 100
  begin


    puts "page: #{page}"
    puts "from row #{page*limit}"
    response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/audit_reports" ,
    :query => {
      :auth_token => auth_token ,
      :page => page ,
      :limit => limit 
    })

    page = page + 1 
    puts "to row #{page*limit}"

    

    server_response =  JSON.parse(response.body ) 

    total_result = server_response["records"].length 

    puts "to row #{page*limit}, total: #{server_response['total']}. Total result: #{total_result}" 

   
    CSV.open( file_location, 'a' ) do |writer| 




      server_response["records"].each do |member|
 
        row_array = []

        row_array  << member["member_id"]
        row_array  <<  member["member_name"]

        row_array  << member["compulsory_savings_amount_by_dec_2014"]

        row_array  << member["voluntary_savings_amount_by_dec_2014"] 
        row_array  << member["membership_savings_amount_by_dec_2014"] 
        row_array  << member["locked_savings_amount_by_dec_2014"] 

        writer << row_array 


      end

    end

  end until total_result ==  0 





end
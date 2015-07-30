
require 'httparty'
require 'json'

FUND_TRANSFER_DIRECTION = {
  :incoming => 1,
  :outgoing => 2 
}

task :fail_authentication do 
  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "haha" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]
end 

task :generate_membership_savings_report_and_post_to_dropbox => :environment do




  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]



  # getting the total member
  response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/get_total_members" ,
  :query => {
    :auth_token => auth_token 
  })

  server_response =  JSON.parse(response.body ) 

  server_response["total"]


  # then , try to generate csv report

    today_kki_date = DateTime.now.in_time_zone 'Jakarta'
    last_year = today_kki_date - 1.years
    beginning_of_last_year = last_year.beginning_of_year
    ending_of_last_year = last_year.end_of_year
    starting_datetime = beginning_of_last_year.utc 
    ending_datetime = ending_of_last_year.utc 

  response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/membership_savings_reports" ,
      :query => {
        :auth_token => auth_token ,
        :page => 1 ,
        :limit => 1000 ,
        :starting_datetime => starting_datetime,
        :ending_datetime => ending_datetime
      })

  server_response =  JSON.parse(response.body ) 

  file_location = "/home/willy/Sites/esman/awesome_csv_report2.csv"

  counter = 0 
  CSV.open( file_location, 'w' ) do |writer| 
    writer << [ "no", "id", "id_number", "nama", "tgl", "jumlah", "tgl", "jumlah"]



    server_response["members"].each do |member|
      counter  = counter  + 1 
      outgoing_list = []
      incoming_list = []

      member["membership_savings_entries"].each do |x|
        if x["direction"].to_i == 1 # FUND_TRANSFER_DIRECTION[:incoming]
          incoming_list  << x 
        else
          outgoing_list  << x
        end
      end


      length = outgoing_list.length
      length = incoming_list.length if incoming_list.length > outgoing_list.length 
      (0.upto (length -1) ).each do |x| 
        row_array  = []
        if x == 0
          row_array << counter 
          row_array  << member["id"]
          row_array  << member["id_number"]
          row_array   << member["name"]
        else
          row_array <<  nil  
          row_array <<  nil  
          row_array  << nil 
          row_array   << nil 
        end

        if not incoming_list[x].nil?
          row_array << incoming_list[x]["confirmed_at"]  if not incoming_list[x].nil? 
          row_array << incoming_list[x]["amount"]  if not incoming_list[x].nil? 
        else
          row_array <<  nil 
          row_array << nil 
        end

        if not outgoing_list[x].nil?
          row_array << outgoing_list[x]["confirmed_at"]  if not outgoing_list[x].nil? 
          row_array << outgoing_list[x]["amount"]  if not outgoing_list[x].nil?
        else
          row_array <<  nil 
          row_array << nil 
        end

        writer << row_array 
      end
      # create first row 


    end

  end



end
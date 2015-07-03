
require 'httparty'
require 'json'

FUND_TRANSFER_DIRECTION = {
  :incoming => 1,
  :outgoing => 2 
}

task :generate_savings_entry_report => :environment do




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

  response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/savings_entry_reports" ,
      :query => {
        :auth_token => auth_token ,
        :page => 1 ,
        :limit => 1000 ,
        :starting_datetime => starting_datetime,
        :ending_datetime => ending_datetime
      })

  server_response =  JSON.parse(response.body ) 

  file_location = "/home/willy/Sites/esman/awesome_saving_entry_report2.csv"

  counter = 0 
  CSV.open( file_location, 'w' ) do |writer| 
    writer << [ "no", "id", "id_number", "nama", "tgl", "jumlah", "tgl", "jumlah"]



    server_response["savings_entries"].each do |savings_entry|
      counter  = counter  + 1 

      row_array = []
      row_array << counter 
      row_array  << savings_entry["id"]
      row_array  << savings_entry["member_id_number"]
      row_array   << savings_entry["member_name"]

      if savings_entry["direction"].to_i == 1 
        row_array   << savings_entry["confirmed_at"]
        row_array   << savings_entry["amount"]
      else
        row_array   <<  nil 
        row_array   << nil
      end

      if savings_entry["direction"].to_i == 2
        row_array   << savings_entry["confirmed_at"]
        row_array   << savings_entry["amount"]
      else
        row_array   <<  nil 
        row_array   << nil
      end


      writer << row_array 


    end

  end



end
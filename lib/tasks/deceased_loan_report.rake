require 'dropbox_sdk'
require 'fileutils'
require 'httparty'
require 'json'


task :generate_deceased_loan_report_and_post_to_dropbox => :environment do




  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    {
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]





    today_kki_date = DateTime.now.in_time_zone 'Jakarta'
    # today_kki_date = DateTime.new(2015,8,5,0,0,0 )
    last_week = today_kki_date - 1.weeks
    last_year = today_kki_date - 1.years
    starting_datetime = year.end_of_day.utc
    ending_datetime = today_kki_date.end_of_day.utc

    today_date_string  = ""
    last_month_date_string = ""
    today_date_string << today_kki_date.year.to_s  + "-"

    if today_kki_date.month.to_s.length == 1
      today_date_string << "0"
    end
    today_date_string << today_kki_date.month.to_s

    if today_kki_date.day.to_s.length == 1
      today_date_string << "0"
    end
    today_date_string << today_kki_date.day.to_s




  counter = 0
  page = 1
  limit = 10
  file_location = "#{DISBURSED_GROUP_LOAN_FILE_LOCATION}/deceased_#{today_date_string}.csv"

  CSV.open( file_location, 'w' ) do |writer|

    header_array = [
      "Nama",
      "No Kelompok",
      "Nama Kelompok",
      "Jumlah Pinjaman",
      "Tanggal Meninggal",
      "Setoran yang sudah lunas"
      ]

    writer << header_array
  end



  begin

    puts "in page: #{page}"
    response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/deceased_members" ,
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

    total_result = server_response["deceased_members"].length

    # puts "total result: #{total_result}"

    page = page + 1

    if total_result != 0

      CSV.open( file_location, 'a' ) do |writer|


        server_response['deceased_members'].each do |deceased_members|
          result_array = []

    # "Group No.", " Group Name", "  Disbursement Date " , "Total Disbursement"



          result_array << deceased_members["name"]
          result_array << deceased_members["group_number"]
          result_array << deceased_members["group_name"]
          result_array << deceased_members["disbursement_amount"]
          result_array << deceased_members["deceased_date"]
          result_array << deceased_members["completed_payment"]

          writer << result_array
        end




      end
    end


  end until total_result == 0


  puts "gonna put to dropbox"
  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)


  file = open( file_location )

  dropbox_file_location  = "/deceased_member/#{today_date_string}.csv"
  client.put_file(dropbox_file_location, file)

  File.delete( file_location )





end

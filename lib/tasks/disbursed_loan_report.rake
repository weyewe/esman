require 'dropbox'
require 'fileutils'
require 'httparty'
require 'json'


task :generate_disburse_loan_report_and_post_to_dropbox => :environment do




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
    last_month = today_kki_date - 1.months
    beginning_of_last_month = last_month.beginning_of_month
    ending_of_last_month = last_month.end_of_month
    starting_datetime = beginning_of_last_month.utc
    ending_datetime = ending_of_last_month.utc

  last_month_date_string = ""
  last_month_date_string << last_month.year.to_s  + "-"

  if last_month.month.to_s.length == 1
    last_month_date_string << "0"
  end
  last_month_date_string << last_month.month.to_s





  counter = 0
  page = 1
  limit = 50
  file_location = "#{DISBURSED_GROUP_LOAN_FILE_LOCATION}/disbursed_#{last_month_date_string}.csv"

  CSV.open( file_location, 'w' ) do |writer|

    header_array = [
        "Group No.", " Group Name", "  Disbursement Date " , "Total Disbursement"

      ]

    writer << header_array
  end



  begin

    puts "in page: #{page}"
    response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/disbursed_group_loans" ,
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

    # "Group No.", " Group Name", "  Disbursement Date " , "Total Disbursement"
          result_array << group_loan["group_number"]
          result_array << group_loan["name"]
          result_array << group_loan["disbursed_at"]
          result_array << group_loan["disbursement_amount"]

          writer << result_array
        end




      end
    end


  end until total_result == 0


  puts "gonna put to dropbox"
  # client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)
  #
  #
  # file = open( file_location )

  dropbox_file_location  = "/disbursed_loan/#{last_month_date_string}.csv"
  # client.put_file(dropbox_file_location, file)


  dropbox_access_token = DROPBOX_ACCESS_TOKEN
  client = Dropbox::Client.new(dropbox_access_token)

  file = open(file_location)
  file = client.upload("#{dropbox_file_location}", file, {
    :mode => "overwrite"
  })



  File.delete( file_location )





end

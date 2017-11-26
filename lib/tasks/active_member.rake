require 'dropbox'
require 'fileutils'
require 'httparty'
require 'json'

task :bentar_localhost => :environment do

  puts "setting up base url"
  base_url = "http://localhost:5000"
  puts "The base url: #{base_url}"

  response = HTTParty.post( "#{base_url}/api2/users/sign_in" ,
    {
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  puts "server_response: #{server_response}"

  auth_token  = server_response["auth_token"]

  puts "tadaaaa.. this is the auth_token #{auth_token}"



end


def bentar_login

  puts "setting up base url"
  base_url = "http://localhost:5000"
  puts "The base url: #{base_url}"

  response = HTTParty.post( "#{base_url}/api2/users/sign_in" ,
    {
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  puts "server_response: #{server_response}"

  auth_token  = server_response["auth_token"]

  puts "tadaaaa.. this is the auth_token #{auth_token}"


  return auth_token
end

task :bentar_test_pass_params => :environment do

  auth_token = bentar_login

  puts "The auth token from bentar_login: #{auth_token}"

base_url = "http://localhost:5000"

  response = HTTParty.post( "#{base_url}/api2/calculate_rico_score" ,
    :query => {
      :auth_token => auth_token
    },
    :body => {
      :savings_entry => {
        :amount        =>  BigDecimal( '500000' ),
        :member_id =>  1755,
        :direction =>   1 # 1 for addition, 2 for withdrawal
      },
      :source_node_key => 23432423,
      :target_node_key => 23432
    }

  )


  server_response =  JSON.parse(response.body )

  puts "The response from server: #{server_response}"
end



task :bentar_test_get_array_result_params => :environment do

  auth_token = bentar_login

  puts "The auth token from bentar_login: #{auth_token}"

base_url = "http://localhost:5000"

  response = HTTParty.get( "#{base_url}/api2/show_connection_path" ,
    :query => {
      :auth_token => auth_token
    },
    :body => {
      :source_node_key => 23432423,
      :target_node_key => 23432,
      :jump => 2
    }

  )


  server_response =  JSON.parse(response.body )

  puts "The response from server: #{server_response}"
end

task :bentar_test_get_api_token => :environment do
  auth_token = bentar_login

  puts "The auth token from bentar_login: #{auth_token}"

  base_url = "http://localhost:5000"

    response = HTTParty.get( "#{base_url}/api2/get_api_social_media" ,
      :query => {
        :auth_token => auth_token
      },
      :body => {
        :source_node_key => 23432423,
        :target_node_key => 23432,
        :jump => 2
      }

    )


    server_response =  JSON.parse(response.body )

    puts "The response from server: #{server_response}"
end

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
  # client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)
  #
  #
  # file = open( file_location )

  dropbox_file_location  = "/aux_kki_report/active_member/#{today_kki_date.year.to_s}.csv"
  # client.put_file(dropbox_file_location, file)


  ####### new dropbox
  dropbox_access_token = DROPBOX_ACCESS_TOKEN
  client = Dropbox::Client.new(dropbox_access_token)

  file = open(file_location)
  file = client.upload("#{dropbox_file_location}", file, {
    :mode => "overwrite"
  })

  File.delete( file_location )





end

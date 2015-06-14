
require 'httparty'
require 'json'


# entry_case ==1  == debit
# entry_case == 2 == credit 


def get_auth_token
  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]
  return auth_token 
end

def get_result_filename( the_date  )
  result_filename = ""
  month_string  = the_date.month.to_s
  year_string   = the_date.year.to_s

  if month_string.length == 1 
    result_filename << "0"  + month_string + "_"
  else
    result_filename << month_string + "_"
  end

  result_filename << year_string + ".csv"

  return result_filename
end


def generate_temp_csv_file( 
      transaction_datas ,
      page,
      limit,
      counter
    )
  file_name = "#{page}.csv"
  file_location = "#{TEMP_FILE_LOC}/#{file_name}"


  CSV.open( file_location, 'w' ) do |writer| 


    transaction_datas.each do |td|
      counter  = counter  + 1 
      outgoing_list = []
      incoming_list = []

      td["transaction_data_details"].each do |x|
        if x["entry_case"].to_i == 1 # FUND_TRANSFER_DIRECTION[:incoming]
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
          row_array  << td["description"] 
        else
          row_array <<  nil  
          row_array <<  nil  
        end

        if not incoming_list[x].nil?
          row_array << incoming_list[x]["account_name"]  if not incoming_list[x].nil? 
          row_array << incoming_list[x]["amount"]  if not incoming_list[x].nil? 
        else
          row_array <<  nil 
          row_array << nil 
        end

        if not outgoing_list[x].nil?
          row_array << outgoing_list[x]["account_name"]  if not outgoing_list[x].nil? 
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


  return [ file_location , counter ] 
end

def extract_transaction_data( starting_datetime, ending_datetime, page, limit, auth_token )
  response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/transaction_datas" ,
    :query => {
      :auth_token => auth_token ,
      :page => page ,
      :limit => limit ,
      :start_date => starting_datetime,
      :end_date => ending_datetime,
      :print_report => true 
    })

  server_response =  JSON.parse(response.body ) 

  return server_response 
end

def generate_temporary_files(auth_token, starting_datetime, ending_datetime)
  temporary_file_array = [] 

  # delete temp folder 
  if  File.directory?(TEMP_FILE_LOC)
    FileUtils.rm_rf( TEMP_FILE_LOC )
  end
  FileUtils.mkdir_p(TEMP_FILE_LOC)

  page = 1 
  limit  = 1000
  total = 0 
  counter = 0 

  begin
    
   puts "page #{page}. gonna get from the server"
   server_response = extract_transaction_data( starting_datetime, ending_datetime, page, limit , auth_token )
   # puts server_response 
   total_result = server_response["transaction_datas"].length
   the_total = server_response["total"]
   puts ".>>>>> the page : #{page*limit}/#{the_total}"
   

    
   if not total_result == 0 
     result = generate_temp_csv_file( 
        server_response["transaction_datas"],
        page,
        limit,
        counter 
      )

     temporary_file_array << result[0]
     counter =  result[1]

   end

   page = page + 1 

   
  end until total_result == 0

  return temporary_file_array
end

def generate_header_file( file_location  )
  CSV.open( file_location, 'w' ) do |writer| 
    writer << [ "",  "", "", "debit", "", "credit"]
    writer << [ "no",  "description", "account", "amount", "account", "amount"]
  end
end


def merge_all_files( result_file_location , temporary_file_array )

  temporary_file_array.each do |temporary_file|
    CSV.open( result_file_location, 'a' ) do |writer| 
      
      CSV.foreach( temporary_file ) do |row|
        writer << row 
      end
    end 
  end

  return result_file_location
end



def generate_csv_report_for_month( the_date ) 
  auth_token = get_auth_token

  beginning_of_month = the_date.beginning_of_month
  ending_of_month = the_date.end_of_month
  starting_datetime = beginning_of_month.utc 
  ending_datetime = ending_of_month.utc 

  result_filename = get_result_filename( the_date  )


  # extract data from the server, and create csv 
  temporary_file_array =  generate_temporary_files( auth_token,starting_datetime,ending_datetime )


  result_file_location = BASE_FILE_LOC + "/#{result_filename}"
  generate_header_file( result_file_location)

  # return result file location to the main 
  result_file_location = merge_all_files(result_file_location,  temporary_file_array ) 

  temporary_file_array.each do |temp_file_loc|
    File.delete( temp_file_loc )
  end

  return result_file_location
end


def upload_report_to_dropbox( file_location, result_filename) 
  client = DropboxClient.new(DROPBOX_ACCESS_TOKEN)
  dropbox_upload_path = "/accounting_report"

  file = open( file_location )

  dropbox_file_location  = "#{dropbox_upload_path}/#{result_filename}"
  client.put_file(dropbox_file_location, file)
end



task :generate_last_month_gl_report => :environment do
  auth_token = get_auth_token 

  today_kki_date = DateTime.now.in_time_zone 'Jakarta'
  last_month = today_kki_date - 1.months

  file_location =  generate_csv_report_for_month( last_month )

  
  upload_report_to_dropbox( file_location, get_result_filename( last_month ) ) 
  File.delete( file_location  )

  puts "done generating file"

end



require 'dropbox_sdk'
require 'fileutils'
require 'httparty'
require 'json'
require 'rubyXL'



task :generate_transaction_data_report => :environment do


 require 'dropbox_sdk'
require 'fileutils'
require 'httparty'
require 'json'
require 'rubyXL'





  response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
    { 
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  auth_token  = server_response["auth_token"]


 
    today_kki_date = DateTime.new(2015,8,5,0,0,0 )
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


    start_date = last_month.year.to_s + "-" + 
                last_month.month.to_s + "-" + 
                last_month.day.to_s


    transaction_source_type_list  =["GroupLoan", 
          "GroupLoanWeeklyCollectionVoluntarySavingsEntry", 
          "GroupLoanWeeklyCollection", 
          "DeceasedClearance", "GroupLoanPrematureClearancePayment", 
          "SavingsEntry"]

    server_response_list = []

    transaction_source_type_list.each do |element|
      response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/transaction_datas" ,
          :query => {
            :auth_token => auth_token ,
            :page => 1 ,
            :limit => 1 ,
            :start_date => start_date ,
            :transaction_source_type => element 
          })

      server_response =  JSON.parse(response.body ) 

      server_response_list << server_response
    end

    workbook = RubyXL::Workbook.new 

    worksheet = workbook[0]


    # 9 == debit, 11 == credit
    worksheet.add_cell(0,9, "Debit")
    worksheet.add_cell(0,11, "Credit")

    worksheet.add_cell(1,0, "Date")
    worksheet.add_cell(1,1, "No")
    worksheet.add_cell(1,2, "Transaction Type")
    worksheet.add_cell(1,3, "Cash in / Cash out/ General Jurnal")
    worksheet.add_cell(1,4, "Group Number")
    worksheet.add_cell(1,5, "Group Name")
    worksheet.add_cell(1,6, "Member ID number")
    worksheet.add_cell(1,7, "Member's Name")
    worksheet.add_cell(1,8, "Set ke")
    worksheet.add_cell(1,9, "Account")
    worksheet.add_cell(1,10, "Amount")
    worksheet.add_cell(1,11, "Account")
    worksheet.add_cell(1,12, "Amount") 


    row_counter = 2 
    day_counter = 1
    server_response_list.each do |x|
      worksheet.add_cell( row_counter, 1, day_counter)

      worksheet.add_cell( row_counter, 2 , x["transaction_datas"].first["transaction_source_type"])
      worksheet.add_cell( row_counter, 4 , x["transaction_datas"].first["group_number"]) 
      worksheet.add_cell(row_counter ,5 , x["transaction_datas"].first["group_name"]) 
      worksheet.add_cell(row_counter ,6, x["transaction_datas"].first["member_id_number"] )
      worksheet.add_cell(row_counter ,7, x["transaction_datas"].first["member_name"])
      worksheet.add_cell(row_counter ,8, x["transaction_datas"].first["set_ke"])

      total_debit = 0
      total_credit =  0
      debit_list = []
      credit_list = [] 

        # debit = 1, credit = 2
      x["transaction_datas"].first["transaction_data_details"].each do |tdd|
        if tdd["entry_case"].to_i == 1 
          total_debit = total_debit + 1 
          debit_list << tdd
        else
          total_credit = total_credit + 1 
          credit_list << tdd
        end
      end

      additional_counter = 0
      debit_list.each do |debit|
        debit_row = row_counter + additional_counter 
        account_name = "[#{debit['account_code']}]"  + " #{debit['account_name']}"
        worksheet.add_cell(debit_row ,9, account_name )
        worksheet.add_cell(debit_row ,10, debit["amount"])
        additional_counter = additional_counter + 1 
      end

      additional_counter = 0
      credit_list.each do |credit|
        credit_row = row_counter + additional_counter 
        account_name = "[#{credit['account_code']}]"  + " #{credit['account_name']}"
        worksheet.add_cell(credit_row ,11, account_name )
        worksheet.add_cell(credit_row ,12,  credit["amount"])
        additional_counter = additional_counter + 1 
      end

      



      row_counter = row_counter + total_debit if total_debit > total_credit 
      row_counter = row_counter + total_credit if total_debit <= total_credit 

    end



    workbook.write( Dir.pwd + "/" + "monthly_report.xlsx")
 
 
  

end
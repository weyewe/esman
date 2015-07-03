require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


task :find_negative => :environment do
	file_location = Rails.root.to_s + "/schwab_reports.csv"
	backdated_array = []

    CSV.open(file_location, 'r') do |csv| 
        csv.each do |row|
        	# puts "id_number: #{row[0]}"
        	id_number = row[0]

        	voluntary_savings_oct_2014 =  BigDecimal( row[6])
        	voluntary_savings_dec_2014 = BigDecimal( row[7])
        	voluntary_savings_may_20015 = BigDecimal( row[8])

        	zero = BigDecimal("0")

        	if voluntary_savings_may_20015 < zero or 
        		voluntary_savings_dec_2014 < zero or 
        		voluntary_savings_oct_2014 < zero 

        		puts "the member with id_number #{id_number} is negative"
        		backdated_array << id_number
        	end
        end
    end


  	response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
	    { 
	      :body => {
	        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
	      }
	    })

	server_response =  JSON.parse(response.body )

	auth_token  = server_response["auth_token"] 


	backdated_array.each do |id_number|
		response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/savings_entries_history/#{id_number}" ,
		  :query => {
		    :auth_token => auth_token 
		  })

		server_response =  JSON.parse(response.body ) 

		file_location = "/home/willy/Sites/esman/backdated/#{id_number}.csv"

	    CSV.open(file_location, 'w') do |csv|

	    	csv << [ "SavingsSource", "Status" , "Amount",  
	    		"Backdated?",  "Diff", "Created At", "Confirmed At", "Running Total" ]

	    	running_total = BigDecimal("0")

	    	server_response["savings_entries"].each do |x|
	    		# puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "
	    		# puts x
	    		result = [] 

	    		if x["financial_product_type"].present? 
	    			result << x["financial_product_type"]
	    		else
	    			result << "Independent"
	    		end
	    		

	    		if x["direction"].to_i == 1 # incoming
	    			result << "Incoming"
	    			running_total = running_total + BigDecimal( x["amount"] )
	    		else
	    			result << "Outgoing"
	    			running_total = running_total - BigDecimal( x["amount"] )
	    		end

	    		result << x["amount"]


	    		puts "before splitting. the x: "
	    		puts x["created_at"]
	    		puts x["confirmed_at"]

	    		next if x["confirmed_at"].nil? 
	    		
	    		created_at_array = x["created_at"].split("-").map{|x| x.to_i }
	    		confirmed_at_array = x["confirmed_at"].split("-").map{|x| x.to_i }

	    		created_at = DateTime.new(
	    				created_at_array[0],
	    				created_at_array[1],
	    				created_at_array[2],
	    				0,0,0
	    			)

	    		confirmed_at = DateTime.new(
	    				confirmed_at_array[0],
	    				confirmed_at_array[1],
	    				confirmed_at_array[2],
	    				0,0,0
	    			)

	    		diff = (created_at - confirmed_at).to_i


	    		if created_at > confirmed_at 
	    			result << "True"
	    		else
	    			result << "False"
	    		end

	    		result << diff
	    		result << x["created_at"]
	    		result << x["confirmed_at"]



	    		result << running_total 

	    		csv << result 

	     
	    	end
 
	    end
	end   
end

# check the history from the server => saings entry 
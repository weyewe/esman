
json.success true 
json.total @total
json.payment_requests @objects do |object|
	json.id 								object.id  
	

 
	 
  json.vendor_name		object.vendor.name  
  json.vendor_id		  object.vendor_id  
	
	json.code 					object.code
	json.description 		object.description
	json.amount 		object.amount
  json.request_date  		format_date_friendly( object.request_date )
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
	  


	
end



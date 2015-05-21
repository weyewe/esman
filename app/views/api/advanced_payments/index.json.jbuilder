
json.success true 
json.total @total
json.advanced_payments @objects do |object|
	json.id 								object.id  	 
  json.home_name		object.home.name  
  json.home_id		  object.home_id  
	json.code 					object.code
	json.description 		object.description
	json.amount 		object.amount
  json.duration 		object.duration
  json.start_date  		format_date_friendly( object.start_date )
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
	  


	
end




json.success true 
json.total @total
json.monthly_generators @objects do |object|
	json.id 								object.id  
 

	
	json.code 					object.code
	json.description 		object.description
  json.generated_date  		format_date_friendly( object.generated_date )
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
	  


	
end



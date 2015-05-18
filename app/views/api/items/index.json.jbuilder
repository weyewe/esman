
json.success true 
json.total @total
json.items @objects do |object|
	json.id 								object.id  
	

 
	 
	json.customer_id		object.customer_id 
	json.item_type_id				object.item_type_id
	
	json.code 								object.code
	json.description 					object.description
	
	json.manufactured_at  		format_date_friendly( object.manufactured_at )  
	json.warranty_expiry_date format_date_friendly( object.warranty_expiry_date )  
	  


	
end



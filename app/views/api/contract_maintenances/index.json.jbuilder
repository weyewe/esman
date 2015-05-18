
json.success true 
json.total @total
json.contracts @objects do |object|
	json.id 								object.id  
	json.code object.code

 
	 
	json.customer_id		object.customer_id
	json.customer_name object.customer.name 
 
	json.name 								object.name
	json.description 					object.description
	
	json.started_at  		format_date_friendly( object.started_at )  
	json.finished_at format_date_friendly( object.finished_at )  
	  


	
end



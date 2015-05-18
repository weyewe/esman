json.success true 
json.total @total
json.maintenances @objects do |object|
	 json.id                   	object.id 
	 json.code										object.code 
	 json.item_code             	object.item.code                                  
	 json.item_id              	object.item.id   
	 json.customer_name         	object.customer.name 	
	 json.customer_id           	object.customer.id   	
	 json.user_id               	object.user.id  
	 json.user_name             	object.user.name 
	
	 json.complaint_date        	format_datetime_friendly(object.complaint_date)   
	 json.complaint             	object.complaint  
	 json.complaint_case          object.complaint_case 
	 json.complaint_case_text   	object.complaint_case_text 
	 json.diagnosis_date        	format_datetime_friendly( object.diagnosis_date )    
	 json.diagnosis             	object.diagnosis   
   json.diagnosis_case       	object.diagnosis_case                 
   json.diagnosis_case_text  	object.diagnosis_case_text 
   json.is_diagnosed         	object.is_diagnosed 
   json.solution_date        	format_datetime_friendly( object.solution_date ) 
   json.solution             	object.solution 
	 json.solution_case        	object.solution_case 
	 json.solution_case_text   	object.solution_case_text 
	 json.is_solved            	object.is_solved 
	 json.is_confirmed         	object.is_confirmed 
   json.is_deleted           	object.is_deleted

end

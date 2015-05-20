
json.success true 
json.total @total
json.home_assignments @objects do |object|
	json.id 								object.id  
	

 
	 
  json.user_id		object.user_id
  json.user_name  object.user.name
  json.home_id		object.home_id
  json.home_name  object.home.name
  json.assignment_date  format_date_friendly(object.assignment_date)
 
	  


	
end



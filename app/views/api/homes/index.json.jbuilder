
json.success true 
json.total @total
json.homes @objects do |object|
	json.id 								object.id  
 
	 
	json.name	object.name
  json.address	object.address
  json.home_type_id	object.home_type_id
  json.home_type_name	object.home_type.name
  json.home_type_description	object.home_type.description
	 


	
end



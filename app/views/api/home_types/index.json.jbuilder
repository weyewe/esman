
json.success true 
json.total @total
json.home_types @objects do |object|
	json.id 								object.id  
 
	 
	json.name	object.name
	json.description	object.description
  json.amount	object.amount
	 


	
end



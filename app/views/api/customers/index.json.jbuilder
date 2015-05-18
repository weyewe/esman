
json.success true 
json.total @total
json.customers @objects do |object|
	json.id 								object.id  
 
	 
	json.name	object.name
	json.address	object.address
	
	json.pic object.pic
	json.contact object.contact
	json.email object.email
	  


	
end



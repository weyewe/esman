json.success true 
json.total @total
json.records @objects do |object|
	json.id 										object.id
	json.item_type_name 						object.item_type.name
	json.code 			object.code 
	json.description 			object.description 
	
end


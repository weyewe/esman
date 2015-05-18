
json.success true 
json.total @total
json.contract_items @objects do |object|
	json.id 								object.id  
	
			
	json.item_id							object.item_id
	json.item_code 						object.item.code 
	json.item_type_name						object.item.type.name 
	json.customer_id					object.customer_id
	json.customer_name				object.customer.name
	json.contract_maintenance_id  object.contract_maintenance_id 
end



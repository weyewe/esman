
json.success true 
json.total @total
json.cash_banks @objects do |object|
  
	json.id 								object.id  			
  json.name							object.name
  json.description 						object.description 
	json.amount						object.amount
	json.is_bank					object.is_bank
	 
end



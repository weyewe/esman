


json.success true 
json.total @total
 

json.payment_voucher_details @objects do |object| 

	json.id 								object.id 
  json.payment_voucher_id 		  object.payment_voucher_id  
  json.payable_id 			 object.payable_id
  json.payable_source_code			 object.payable.source_code
	json.amount 						object.amount 
	
	
	
end

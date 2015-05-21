
json.success true 
json.total @total
 

json.payment_vouchers @objects do |object|

	json.id 								object.id 
  json.payment_date 			 format_date_friendly( object.payment_date )   
	json.description 			 object.description
  json.vendor_id 			 object.vendor_id
  json.vendor_name 			 object.vendor.name
  json.cash_bank_id 			 object.cash_bank_id
  json.cash_bank_name 			 object.cash_bank.name
  json.description 			 object.description
	json.is_confirmed 			 object.is_confirmed
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
	json.amount 					 object.amount
	json.is_deleted 						object.is_deleted 
	json.deleted_at 	format_date_friendly( 	object.deleted_at ) 
	
	
end

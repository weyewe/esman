
json.success true 
json.total @total
json.receipt_vouchers @objects do |object|
	json.id 								object.id  
	

 
	 
  json.user_name		object.user.name  
  json.user_id		  object.user_id  
  json.cash_bank_name		object.cash_bank.name  
  json.cash_bank_id		  object.cash_bank_id  
  json.receivable_id		  object.receivable_id
  json.receivable_source_code	  object.receivable.source_code
	json.code 					object.code
	json.description 		object.description
	json.amount 		object.amount
  json.receipt_date  		format_date_friendly( object.receipt_date )
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
	  


	
end



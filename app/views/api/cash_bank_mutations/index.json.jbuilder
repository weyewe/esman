
json.success true 
json.total @total
json.cash_bank_mutations @objects do |object|
	json.id 								object.id  
 
	 
  json.source_cash_bank_id	object.source_cash_bank_id
  json.target_cash_bank_id	object.target_cash_bank_id
  json.source_cash_bank_name	object.source_cash_bank.name
  json.target_cash_bank_name	object.target_cash_bank.name
  
  
  json.code	object.code
	
	json.description 	object.description
	json.amount 		  object.amount
	json.mutation_date  format_date_friendly( object.mutation_date )
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  


end




json.success true 
json.total @total
json.cash_bank_adjustments @objects do |object|
	json.id 								object.id  
 
	 
  json.cash_bank_id	object.cash_bank_id
  json.cash_bank_name	object.cash_bank.name
  json.code	object.code
	
	json.description 	object.description
	json.amount 		  object.amount
	json.status 		  object.status
	json.adjustment_date  format_date_friendly( object.adjustment_date )
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
	

    if object.status == ADJUSTMENT_STATUS[:addition]
      json.status_text  "Penambahan"
    else
      json.status_text "Pengurangan"
    end
end



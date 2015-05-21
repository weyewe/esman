
json.success true 
json.total @total
json.cash_mutations @objects do |object|
  
	json.id 								object.id  			
  json.source_class							object.source_class
  json.source_id 						object.source_id 
  json.source_code 						object.source_code 
  json.cash_bank_id 						object.cash_bank_id 
  json.cash_bank_name				object.cash_bank.name
	json.amount						object.amount
  json.status        object.status 
  json.mutation_date       format_date_friendly( object.mutation_date ) 
  if object.status == ADJUSTMENT_STATUS[:addition]
      json.status_text  "Penambahan"
    else
      json.status_text "Pengurangan"
    end
end



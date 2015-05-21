
json.success true 
json.total @total
json.invoices @objects do |object|
  
	json.id 								object.id  			
  json.source_class							object.source_class
  json.source_id 						object.source_id 
  json.source_code 						object.source_code 
  json.home_id 						object.home_id 
  json.code 						object.code 
  json.home_name				object.home.name
	json.amount						object.amount
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.due_date  		format_date_friendly( object.due_date ) 
  json.is_confirmed   object.is_confirmed  
  json.invoice_date       format_date_friendly( object.invoice_date )  
  
end



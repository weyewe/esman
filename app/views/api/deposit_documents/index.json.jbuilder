
json.success true 
json.total @total
json.deposit_documents @objects do |object|
	json.id 								object.id  
 
	 
  json.code	object.code
  json.deposit_date	format_date_friendly( object.deposit_date )
  json.user_id	object.user_id
  json.user_name	object.user.name
  json.home_id	object.home_id
  json.home_name	object.home.name
	json.description 	object.description
  json.amount_deposit object.amount_deposit
  json.amount_charge object.amount_charge
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
  json.finished_at  		format_date_friendly( object.finished_at )  
  json.is_finished   object.is_finished  

end



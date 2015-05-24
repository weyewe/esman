role = {
  'system' => {
    'administrator' => true
  }
}

admin_role = Role.create!(
  :name        => ROLE_NAME[:admin],
  :title       => 'Administrator',
  :description => 'Role for administrator',
  :the_role    => role.to_json
)

# admin_role = TheRole.create_admin!

# update admin_role
# https://github.com/TheRole/docs/blob/master/MigrationsFromV2.md
# change role.rb 
#  admin_role.create_rule(:system, :administrator)
      # admin_role.rule_on(:system, :administrator)
# 

role = {
  :passwords => {
    :update => true 
  },
  :works => {
    :index => true, 
    :create => true,
    :update => true,
    :destroy => true,
    :work_reports => true ,
    :project_reports => true ,
    :category_reports => true 
  },
  :projects => {
    :search => true 
  },
  :categories => {
    :search => true 
  }
}

data_entry_role = Role.create!(
  :name        => ROLE_NAME[:data_entry],
  :title       => 'Data Entry',
  :description => 'Role for data_entry',
  :the_role    => role.to_json
)



# if Rails.env.development?

  admin = User.create_main_user(  :name => "Admin", :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user


  admin = User.create_main_user(  :name => "Admin2", :email => "admin2@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
  admin = User.create_main_user(  :name => "Admin4", :email => "admin4@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
data_entry = User.create_object(
  :name => "jojo",
  :email => "jojo@gmail.com",
  :password => "jojo1234",
  :password_confirmation => "jojo1234",
  :role_id => data_entry_role.id
  )


(1.upto 20).each do |x| 
  Vendor.create_object(
    :name => "Vendor #{x}",
    :address => "alamat vendor kita",
    :description => "boom! this is the description"
    )
end

home_type_array = []
["ruko 1 lantai", "ruko 2 lantai", "ruko corner", "rumah tipe 21", "rumah tipe 88"].each do |x|
  home_type =  HomeType.create_object(
    :name => x,
    :description => "Description of #{x}",
    :amount => rand(1..10) * BigDecimal("40000")
    )
  home_type_array << home_type 
end


cash_bank_array = []
["BCA", "MANDIRI", "BCA2", "MANDIRI2", "KAS"].each do |x|
  cash_bank =  CashBank.create_object(
    :name => x,
    :description => "Description of #{x}",
    )
  cash_bank_array << cash_bank 
end

home_array = []
total_home_type = home_type_array.length 
(1.upto 20).each do |x|  
  selected_home_type = home_type_array[ rand(0..(total_home_type-1) )]
  home = Home.create_object(
    :home_type_id => selected_home_type.id ,
    :name => "#{x} #{selected_home_type.name} ",
    :address => "The address"
    )
  home_array << home 
end

user_array = []
User.all.each {|u| user_array << u }

total_user = user_array.length 

home_array.each do |home|
  selected_user = user_array[ rand(0..(total_user-1) )]
  
  HomeAssignment.create_object(
    :user_id => selected_user.id ,
    :home_id => home.id ,
    :assignment_date => DateTime.now 
    
    )
end
  

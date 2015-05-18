role = {
  :system => {
    :administrator => true
  }
}

admin_role = Role.create!(
  :name        => ROLE_NAME[:admin],
  :title       => 'Administrator',
  :description => 'Role for administrator',
  :the_role    => role.to_json
)

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


  
  customer_1 = Customer.create_object(
    :name        => "mcnell", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "walawee@gmail.com", 
  )
  
  customer_2 = Customer.create_object(
    :name        => "toll", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "toll@gmail.com", 
  )
  
  customer_3 = Customer.create_object(
    :name        => "penanshin", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "toll@gmail.com", 
  )
  
  customer_array = [customer_1, customer_2, customer_3 ]
  
  item_type_pc = ItemType.create_object(
    :name => "PC",
    :description => "Seperangkat komputer: mouse, CPU, Monitor, Speaker (optional)"
  )
  
  item_type_laptop = ItemType.create_object(
    :name => "Laptop",
    :description => "Awesome"
  )
  
  item_type_array = [item_type_pc, item_type_laptop]
  
  
  (1..3).each do |x|
    customer_array.each do |customer_object|
      item_type_array.each do |type_object|
        
        a=  Item.create_object(
          :customer_id              => customer_object.id,
          :item_type_id                  => type_object.id,
          :description              => "#{customer_object.name} #{type_object.name} #{x} ",
          :manufactured_at          => DateTime.new(2011, 10,10), 
          :warranty_expiry_date     => DateTime.new(2013, 10,10)
        )
        
        a.errors.messages.each {|x| puts "Item error: #{x}"}
      end
    end
  end
  
  puts "Total item: #{Item.all.count}"
  
  
   
   customer = Customer.first
   customer.items.each do |item|
     Maintenance.create_object(
       :item_id        => item.id, 
       :customer_id    => customer.id           ,
       :user_id        => User.first.id         ,
       :complaint_date => DateTime.now          ,
       :complaint      => "awesome complaint"   ,
       :complaint_case => MAINTENANCE_CASE[:emergency]
      )
   end
  
  
  puts "Total maintenance: #{Maintenance.all.count}"
  
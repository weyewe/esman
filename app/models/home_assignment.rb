class HomeAssignment < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :home_id
  validates_presence_of :assignment_date
  
  validate :valid_user_and_valid_home 
  
  belongs_to :user
  belongs_to :home 
  
  
  def valid_user_and_valid_home
    return if user_id.nil? or home_id.nil? 

    user = User.find_by_id(user_id)
    home = Home.find_by_id( home_id )
    
    if user.nil?
      self.errors.add(:user_id , "Harus ada user yang dipilih")
      return self
    end
    
    if home.nil?
      self.errors.add(:home , "Harus ada home yang dipilih")
      return self
    end
      
    previous_assignment_counter = HomeAssignment.where(
      :home_id => home.id,
      :user_id => user.id,
      :is_deleted => false 
      ).count
    
    if self.persisted? 
      if previous_assignment_counter > 1 
        self.errors.add(:generic_errors, "Sudah ada")
        return self 
      end
    else
      if previous_assignment_counter > 0
        self.errors.add(:generic_errors, "Sudah ada")
        return self 
      end
    end
    
      
  end
  
  def valid_home
    return if home_id.nil? 

    home = Home.find_by_id(home_id)
    
    if home.nil? 
      self.errors.add(:home_id, "Harus ada Home")
      return self
    end
  end
  
  def self.create_object (params)
    new_object = self.new
    new_object.user_id = params[:user_id]
    new_object.home_id = params[:home_id]
    new_object.assignment_date = params[:assignment_date]
    new_object.save
    return new_object
  end
  
  def update_object (params)
    self.user_id = params[:user_id]
    self.home_id = params[:home_id]
    self.assignment_date = params[:assignment_date]
    self.save
  end
  
  def delete_object
    self.is_deleted = true
    self.save
  end
  
end

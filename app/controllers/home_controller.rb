class HomeController < ApplicationController

  
  skip_before_filter :authenticate_user!

  def index
    render layout: "extjs"
  end



  def overview 
  end

  def property_type 
  end

  def facility 
  end

  def location 
  end
end

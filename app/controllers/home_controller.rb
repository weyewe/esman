class HomeController < ApplicationController
  def index
  end



  def overview
	render layout: "public"
  end

  def property_type
  	render layout: "public"
  end

  def facility
  	render layout: "public"
  end

  def location
  	render layout: "public"
  end
end

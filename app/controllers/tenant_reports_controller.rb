class TenantReportsController < ApplicationController
	layout "tenant_reports"

	def tenant_invoice_history
	end



	def outstanding_invoice
		# @home_id_list = current_user.homes.where(:is_deleted => false ).map{|x| x.id }
		 
		@objects = Home.order("id DESC").page(params[:page]).per(5)
		# @object = 
		# @objects = Home.page(1).per(params[:limit]).order("id DESC")
    	# @total = Home.count
	end

end

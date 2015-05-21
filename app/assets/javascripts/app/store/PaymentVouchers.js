Ext.define('AM.store.PaymentVouchers', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PaymentVoucher'],
  	model: 'AM.model.PaymentVoucher',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 20, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});

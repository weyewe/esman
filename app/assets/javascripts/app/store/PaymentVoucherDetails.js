Ext.define('AM.store.PaymentVoucherDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PaymentVoucherDetail'],
  	model: 'AM.model.PaymentVoucherDetail',
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

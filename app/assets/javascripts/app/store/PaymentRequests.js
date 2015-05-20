Ext.define('AM.store.PaymentRequests', {
	extend: 'Ext.data.Store',
	require : ['AM.model.PaymentRequest'],
	model: 'AM.model.PaymentRequest',
	// autoLoad: {start: 0, limit: this.pageSize},
	autoLoad : false, 
	autoSync: false,
	pageSize : 10, 
	
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 
	listeners: {

	} 
});

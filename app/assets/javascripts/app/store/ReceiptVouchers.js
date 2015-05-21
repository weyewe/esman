Ext.define('AM.store.ReceiptVouchers', {
	extend: 'Ext.data.Store',
	require : ['AM.model.ReceiptVoucher'],
	model: 'AM.model.ReceiptVoucher',
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

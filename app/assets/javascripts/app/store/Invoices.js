Ext.define('AM.store.Invoices', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Invoice'],
	model: 'AM.model.Invoice',
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

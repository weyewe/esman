Ext.define('AM.store.MonthlyGeneratorInvoices', {
	extend: 'Ext.data.Store',
	require : ['AM.model.MonthlyGeneratorInvoice'],
	model: 'AM.model.MonthlyGeneratorInvoice',
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

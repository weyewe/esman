Ext.define('AM.store.AdvancedPayments', {
	extend: 'Ext.data.Store',
	require : ['AM.model.AdvancedPayment'],
	model: 'AM.model.AdvancedPayment',
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

Ext.define('AM.store.MonthlyGenerators', {
	extend: 'Ext.data.Store',
	require : ['AM.model.MonthlyGenerator'],
	model: 'AM.model.MonthlyGenerator',
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

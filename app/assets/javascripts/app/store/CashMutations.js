Ext.define('AM.store.CashMutations', {
	extend: 'Ext.data.Store',
	require : ['AM.model.CashMutation'],
	model: 'AM.model.CashMutation',
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

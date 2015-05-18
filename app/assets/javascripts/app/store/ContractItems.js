Ext.define('AM.store.ContractItems', {
	extend: 'Ext.data.Store',
	require : ['AM.model.ContractItem'],
	model: 'AM.model.ContractItem',
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

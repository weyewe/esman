Ext.define('AM.store.HomeTypes', {
	extend: 'Ext.data.Store',
	require : ['AM.model.HomeType'],
	model: 'AM.model.HomeType',
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

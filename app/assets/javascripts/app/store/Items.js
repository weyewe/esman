Ext.define('AM.store.Items', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Item'],
	model: 'AM.model.Item',
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

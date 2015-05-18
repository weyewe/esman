Ext.define('AM.store.ItemTypes', {
	extend: 'Ext.data.Store',
	require : ['AM.model.ItemType'],
	model: 'AM.model.ItemType',
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

Ext.define('AM.store.Homes', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Home'],
	model: 'AM.model.Home',
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

Ext.define('AM.store.Contracts', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Contract'],
	model: 'AM.model.Contract',
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

Ext.define('AM.store.Maintenances', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Maintenance'],
	model: 'AM.model.Maintenance',
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

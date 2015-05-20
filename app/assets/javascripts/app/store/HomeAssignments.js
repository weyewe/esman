Ext.define('AM.store.HomeAssignments', {
	extend: 'Ext.data.Store',
	require : ['AM.model.HomeAssignment'],
	model: 'AM.model.HomeAssignment',
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

Ext.define('AM.store.Vendors', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Vendor'],
	model: 'AM.model.Vendor',
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

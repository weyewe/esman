Ext.define('AM.store.DepositDocuments', {
	extend: 'Ext.data.Store',
	require : ['AM.model.DepositDocument'],
	model: 'AM.model.DepositDocument',
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

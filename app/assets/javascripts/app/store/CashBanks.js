Ext.define('AM.store.CashBanks', {
	extend: 'Ext.data.Store',
	require : ['AM.model.CashBank'],
	model: 'AM.model.CashBank',
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

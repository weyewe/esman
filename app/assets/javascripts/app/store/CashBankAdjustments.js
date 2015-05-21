Ext.define('AM.store.CashBankAdjustments', {
	extend: 'Ext.data.Store',
	require : ['AM.model.CashBankAdjustment'],
	model: 'AM.model.CashBankAdjustment',
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

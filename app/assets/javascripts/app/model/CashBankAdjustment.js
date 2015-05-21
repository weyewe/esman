Ext.define('AM.model.CashBankAdjustment', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'cash_bank_id', type: 'int' },
      { name: 'cash_bank_name', type: 'string' },
      { name: 'code', type: 'string' },
      { name: 'status', type: 'int' },
      { name: 'status_text', type: 'string' },
			{ name: 'description', type: 'string' },
      { name: 'adjustment_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
      { name: 'is_confirmed', type: 'boolean' },
      { name: 'amount', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/cash_bank_adjustments',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'cash_bank_adjustments',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { cash_bank_adjustment : record.data };
				}
			}
		}
	
  
});

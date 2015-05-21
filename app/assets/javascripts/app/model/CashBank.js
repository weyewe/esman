Ext.define('AM.model.CashBank', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' },
      { name: 'is_bank', type: 'boolean' },
			{ name: 'amount', type: 'string' },
     
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/cash_banks',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'cash_banks',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { cash_bank : record.data };
				}
			}
		}
	
  
});

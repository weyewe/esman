Ext.define('AM.model.CashBankMutation', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'source_cash_bank_id', type: 'int' },
      { name: 'source_cash_bank_name', type: 'string' },
      { name: 'target_cash_bank_id', type: 'int' },
      { name: 'target_cash_bank_name', type: 'string' },
      { name: 'code', type: 'string' },
     
			{ name: 'description', type: 'string' },
      { name: 'mutation_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
      { name: 'is_confirmed', type: 'boolean' },
      { name: 'amount', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/cash_bank_mutations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'cash_bank_mutations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { cash_bank_mutation : record.data };
				}
			}
		}
	
  
});

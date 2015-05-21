Ext.define('AM.model.CashMutation', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'source_class', type: 'string' },
      { name: 'source_id', type: 'int' },
      { name: 'source_code', type: 'string' },
      { name: 'amount', type: 'string' },
      { name: 'mutation_date', type: 'string' },
      { name: 'status', type: 'int' },
      { name: 'status_text', type: 'string' },
      { name: 'cash_bank_name', type: 'string' },
      { name: 'cash_bank_id', type: 'int' },
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/cash_mutations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'cash_mutations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { cash_mutation : record.data };
				}
			}
		}
	
  
});

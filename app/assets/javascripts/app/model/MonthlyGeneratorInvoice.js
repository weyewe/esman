Ext.define('AM.model.MonthlyGeneratorInvoice', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'source_class', type: 'string' },
      { name: 'source_id', type: 'int' },
      { name: 'home_id', type: 'int' },
      { name: 'home_name', type: 'string' },
      { name: 'code', type: 'string' },
      { name: 'source_code', type: 'string' },
      { name: 'amount', type: 'string' },
      { name: 'invoice_date', type: 'string' },
      { name: 'due_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
		  { name: 'is_confirmed', type: 'boolean' },
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/monthly_generator_invoices',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'monthly_generator_invoices',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { invoice : record.data };
				}
			}
		}
	
  
});

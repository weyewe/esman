Ext.define('AM.model.AdvancedPayment', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'home_name', type: 'string' },
			{ name: 'home_id', type: 'int' },
      { name: 'code', type: 'string' },
      { name: 'amount', type: 'string' },
      { name: 'description', type: 'string' },
      { name: 'duration', type: 'string' },
      { name: 'start_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
		  { name: 'is_confirmed', type: 'boolean' },
  	],
   
  	idProperty: 'id' ,proxy: {
			url: 'api/advanced_payments',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'advanced_payments',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { advanced_payment : record.data };
				}
			}
		}
	
  
});

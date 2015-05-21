Ext.define('AM.model.MonthlyGenerator', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },		
      { name: 'code', type: 'string' },
      { name: 'description', type: 'string' },
      { name: 'generated_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
		  { name: 'is_confirmed', type: 'boolean' },
  	],
   
  	idProperty: 'id' ,proxy: {
			url: 'api/monthly_generators',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'monthly_generators',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { monthly_generator : record.data };
				}
			}
		}
	
  
});

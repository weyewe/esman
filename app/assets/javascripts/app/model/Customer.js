Ext.define('AM.model.Customer', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'address', type: 'string' },
			
    	{ name: 'pic', type: 'string' } ,
			{ name: 'contact', type: 'string' } ,
			{ name: 'email', type: 'string' }
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/customers',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'customers',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { customer : record.data };
				}
			}
		}
	
  
});

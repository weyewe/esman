Ext.define('AM.model.Vendor', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'address', type: 'string' },
      { name: 'description', type: 'string' },
			 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/vendors',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'vendors',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { vendor : record.data };
				}
			}
		}
	
  
});

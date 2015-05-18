Ext.define('AM.model.Item', {
  	extend: 'Ext.data.Model',
  	fields: [
 

    	{ name: 'id', type: 'int' },
			{ name: 'customer_id', type: 'int' },
			{ name: 'item_type_id', type: 'int' },
			
    	{ name: 'code', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			{ name: 'manufactured_at', type: 'string' },
			{ name: 'warranty_expiry_date', type: 'string' }
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/items',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'items',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { item : record.data };
				}
			}
		}
	
  
});

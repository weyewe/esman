Ext.define('AM.model.ItemType', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' },
			 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/item_types',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'item_types',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { item_type : record.data };
				}
			}
		}
	
  
});

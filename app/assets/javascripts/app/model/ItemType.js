Ext.define('AM.model.ItemType', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', item_type: 'int' },
			{ name: 'name', item_type: 'string' },
			{ name: 'description', item_type: 'string' },
			 
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

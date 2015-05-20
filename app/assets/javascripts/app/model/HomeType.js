Ext.define('AM.model.HomeType', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' },
      { name: 'amount', type: 'string' },
			 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/home_types',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'home_types',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { home_type : record.data };
				}
			}
		}
	
  
});

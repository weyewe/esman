Ext.define('AM.model.Home', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'address', type: 'string' },
      { name: 'home_type_id', type: 'int' },
      { name: 'home_type_name', type: 'string' },
      { name: 'home_type_description', type: 'string' },
			 
  	],
   
  	idProperty: 'id' ,proxy: {
			url: 'api/homes',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'homes',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { home : record.data };
				}
			}
		}
	
  
});

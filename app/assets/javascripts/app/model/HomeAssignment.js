Ext.define('AM.model.HomeAssignment', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'user_id', type: 'int' },
      { name: 'user_name', type: 'string' },
      { name: 'home_name', type: 'string' },
			{ name: 'home_id', type: 'int' },
      { name: 'assignment_date', type: 'string' },
			 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/home_assignments',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'home_assignments',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { home_assignment : record.data };
				}
			}
		}
	
  
});

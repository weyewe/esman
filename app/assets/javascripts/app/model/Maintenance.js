Ext.define('AM.model.Maintenance', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'code', type: 'string' },
			{ name: 'item_code', type: 'string' },
			{ name: 'item_id', type: 'int' },
			
			{ name: 'customer_name', type: 'string' },
			{ name: 'customer_id', type: 'int' },
			
			{ name: 'user_name', type: 'string' },
			{ name: 'user_id', type: 'int' },
			
    	{ name: 'complaint_date', type: 'string' } ,
			{ name: 'complaint', type: 'string' } ,
			{ name: 'complaint_case', type: 'int' },
			{ name: 'complaint_case_text', type: 'string' },
			
			{ name: 'diagnosis_date', type: 'string' } ,
			{ name: 'diagnosis', type: 'string' } ,
			{ name: 'diagnosis_case', type: 'int' },
			{ name: 'diagnosis_case_text', type: 'string' },
			
			{ name: 'is_diagnosed', type: 'boolean' },
			
			{ name: 'solution_date', type: 'string' } ,
			{ name: 'solution', type: 'string' } ,
			{ name: 'solution_case', type: 'int' },
			{ name: 'solution_case_text', type: 'string' },
			
			{ name: 'is_solved', type: 'boolean' },
			{ name: 'is_confirmed', type: 'boolean' },
			{ name: 'is_deleted', type: 'boolean' },
			
			
		
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/maintenances',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'maintenances',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { maintenance : record.data };
				}
			}
		}
	
  
});

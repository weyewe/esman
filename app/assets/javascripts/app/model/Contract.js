Ext.define('AM.model.Contract', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'customer_id', type: 'int' },
			{ name: 'customer_name', type: 'string' },
			
			{ name: 'contract_maintenance_id', type: 'string' },
			{ name: 'code', type: 'string' } ,
    	{ name: 'name', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			{ name: 'started_at', type: 'string' },
			{ name: 'finished_at', type: 'string' }
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/contract_maintenances',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'contracts',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { contract : record.data };
				}
			}
		}
	
  
});

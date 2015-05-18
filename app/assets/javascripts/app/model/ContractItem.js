Ext.define('AM.model.ContractItem', {
  	extend: 'Ext.data.Model',
  	fields: [

 
		
    	{ name: 'id', type: 'int' },
			{ name: 'item_id', type: 'int' },
			{ name: 'customer_id', type: 'int' },
			{ name: 'item_code', type: 'string' } ,
			{ name: 'item_type_name', type: 'string' } ,
    	{ name: 'customer_name', type: 'string' } ,
			{ name: 'contract_maintenance_id', type: 'int' }  
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/contract_items',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'contract_items',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { contract_item : record.data };
				}
			}
		}
	
  
});

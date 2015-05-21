Ext.define('AM.model.DepositDocument', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'user_id', type: 'int' },
      { name: 'user_name', type: 'string' },
      { name: 'home_id', type: 'int' },
      { name: 'home_name', type: 'string' },
      { name: 'code', type: 'string' },    
			{ name: 'description', type: 'string' },
      { name: 'deposit_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
      { name: 'is_confirmed', type: 'boolean' },
      { name: 'finished_at', type: 'string' },
      { name: 'is_finished', type: 'boolean' },
      { name: 'amount_deposit', type: 'string' },
      { name: 'amount_charge', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/deposit_documents',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'deposit_documents',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { deposit_document : record.data };
				}
			}
		}
	
  
});

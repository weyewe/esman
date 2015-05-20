Ext.define('AM.model.PaymentRequest', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'vendor_name', type: 'string' },
			{ name: 'vendor_id', type: 'int' },
      { name: 'code', type: 'string' },
      { name: 'amount', type: 'string' },
      { name: 'description', type: 'string' },
      { name: 'request_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
		  { name: 'is_confirmed', type: 'boolean' },
  	],
   
  	idProperty: 'id' ,proxy: {
			url: 'api/payment_requests',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payment_requests',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payment_request : record.data };
				}
			}
		}
	
  
});

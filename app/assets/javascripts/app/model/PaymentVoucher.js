Ext.define('AM.model.PaymentVoucher', {
  	extend: 'Ext.data.Model',
  	fields: [

	 
    	{ name: 'id', type: 'int' },
      { name: 'vendor_id', type: 'int' },
      { name: 'vendor_name', type: 'string' },
      { name: 'cash_bank_id', type: 'int' },
      { name: 'cash_bank_name', type: 'string' },
      { name: 'amount', type: 'string' },
    	{ name: 'payment_date', type: 'string' },
			{ name: 'description', type: 'string' } ,
			{ name: 'is_confirmed', type: 'boolean' } ,  // on start group loan
			{ name: 'confirmed_at', type: 'string' }   ,
			{ name: 'code', type: 'string' }   ,
			{ name: 'is_deleted', type: 'boolean' }   ,
			{ name: 'deleted_at', type: 'string' }  ,
      
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payment_vouchers',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payment_vouchers',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payment_voucher : record.data };
				}
			}
		}
	
  
});

Ext.define('AM.model.PaymentVoucherDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

    	{ name: 'id', type: 'int' },
    	{ name: 'amount', type: 'string' },
			{ name: 'payment_voucher_id', type: 'int' } ,
			{ name: 'payable_id', type: 'int' } ,  // on start group loan
			{ name: 'payable_source_code', type: 'string' } 		
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payment_voucher_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payment_voucher_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payment_voucher_detail : record.data };
				}
			}
		}
	
  
});

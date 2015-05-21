Ext.define('AM.model.ReceiptVoucher', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'user_name', type: 'string' },
			{ name: 'user_id', type: 'int' },
      { name: 'cash_bank_name', type: 'string' },
      { name: 'cash_bank_id', type: 'int' },
      { name: 'receivable_id', type: 'int' },
      { name: 'receivable_source_code', type: 'string' },
      { name: 'code', type: 'string' },
      { name: 'amount', type: 'string' },
      { name: 'description', type: 'string' },
      { name: 'receipt_date', type: 'string' },
      { name: 'confirmed_at', type: 'string' },
		  { name: 'is_confirmed', type: 'boolean' },
  	],
   
  	idProperty: 'id' ,proxy: {
			url: 'api/receipt_vouchers',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'receipt_vouchers',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { receipt_voucher : record.data };
				}
			}
		}
	
  
});

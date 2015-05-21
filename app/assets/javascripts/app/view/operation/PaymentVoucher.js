Ext.define('AM.view.operation.PaymentVoucher', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.paymentvoucherProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'paymentvoucherlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'paymentvoucherdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});
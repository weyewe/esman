Ext.define('AM.view.operation.MonthlyGenerator', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.monthlygeneratorProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		items : [
		// list of group loan.. just the list.. no CRUD etc
    
			{
				xtype : 'monthlygeneratorlist',
				flex : 1
			},
			
			{
				xtype : 'monthlygeneratorinvoiceList',
				flex : 1
			}, 
		]
});
Ext.define('AM.view.master.Item', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.itemProcess',
	 
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
				xtype : 'mastercustomerList',
				flex : 1
			},
			
			{
				xtype : 'itemlist',
				flex : 2
			}, 
		]
});
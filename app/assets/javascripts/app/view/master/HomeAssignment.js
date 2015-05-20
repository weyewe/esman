Ext.define('AM.view.master.HomeAssignment', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.homeassignmentProcess',
	 
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
				xtype : 'masterhomeList',
				flex : 1
			},
			
			{
				xtype : 'homeassignmentlist',
				flex : 2
			}, 
		]
});
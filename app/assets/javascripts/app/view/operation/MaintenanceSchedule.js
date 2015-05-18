Ext.define('AM.view.operation.MaintenanceSchedule', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.maintenancescheduleProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		items : [
			// {
			// 	type : 'panel',
			// 	html : 'this is the operation order'
			// }
			{
				xtype : 'maintenanceschedulelist' ,
				flex : 1  
			},
			{
				xtype : 'maintenancescheduleentrylist',
				flex : 1 
			}
		]
});
Ext.define("AM.controller.Operation", {
	extend : "AM.controller.BaseTreeBuilder",
	views : [
		"operation.OperationProcessList",
		'OperationProcessPanel',
		'Viewport'
	],

	 
	
	refs: [
		{
			ref: 'operationProcessPanel',
			selector: 'operationProcessPanel'
		} ,
		{
			ref: 'operationProcessList',
			selector: 'operationProcessList'
		}  
	],
	

	 
	init : function( application ) {
		var me = this; 
		 
		// console.log("starting the init in Operation.js");
		me.control({
			"operationProcessPanel" : {
				activate : this.onActiveProtectedContent,
				deactivate : this.onDeactivated
			} 
			
		});
		
	},
	
	onDeactivated: function(){
		// console.log("Operation process panel is deactivated");
		var worksheetPanel = Ext.ComponentQuery.query("operationProcessPanel #operationWorksheetPanel")[0];
		worksheetPanel.setTitle(false);
		// worksheetPanel.setHeader(false);
		worksheetPanel.removeAll();		 
		var defaultWorksheet = Ext.create( "AM.view.operation.Default");
		worksheetPanel.add(defaultWorksheet); 
	},
	
	 

	scheduledFolder : {
		text 			: "Scheduled", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'Maintenance A', 
				viewClass:'AM.view.operation.Maintenance', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'maintenances',
					action : 'index'
				}
				]
			}, 
			 
    ]
	},
	
	emergencyFolder : {
		text 			: "Emergency", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'Ticket', 
				viewClass:'AM.view.operation.Item', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'items',
						action : 'index'
					}
				]
			},
			{ 
				text:'Result', 
				viewClass:'AM.view.operation.Contract', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'contract_maintenances',
						action : 'index'
					}
				]
			},
    ]
	},
	   
	 
	onActiveProtectedContent: function( panel, options) {
		var me  = this; 
		var currentUser = Ext.decode( localStorage.getItem('currentUser'));
		var email = currentUser['email'];
		
		me.folderList = [
			this.scheduledFolder,
			// this.emergencyFolder
			// this.inventoryFolder,
			// this.reportFolder,
			// this.projectReportFolder
		];
		
		var processList = panel.down('operationProcessList');
		processList.setLoading(true);
	
		var treeStore = processList.getStore();
		treeStore.removeAll(); 
		
		treeStore.setRootNode( this.buildNavigation(currentUser) );
		processList.setLoading(false);
	},
});
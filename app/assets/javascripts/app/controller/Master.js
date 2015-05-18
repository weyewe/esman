Ext.define("AM.controller.Master", {
	extend : "AM.controller.BaseTreeBuilder",
	views : [
		"master.MasterProcessList",
		'MasterProcessPanel',
		'Viewport'
	],

	 
	
	refs: [
		{
			ref: 'masterProcessPanel',
			selector: 'masterProcessPanel'
		} ,
		{
			ref: 'masterProcessList',
			selector: 'masterProcessList'
		}  
	],
	

	 
	init : function( application ) {
		var me = this; 
		 
		// console.log("starting the init in Master.js");
		me.control({
			"masterProcessPanel" : {
				activate : this.onActiveProtectedContent,
				deactivate : this.onDeactivated
			} 
			
		});
		
	},
	
	onDeactivated: function(){
		// console.log("Master process panel is deactivated");
		var worksheetPanel = Ext.ComponentQuery.query("masterProcessPanel #worksheetPanel")[0];
		worksheetPanel.setTitle(false);
		// worksheetPanel.setHeader(false);
		worksheetPanel.removeAll();		 
		var defaultWorksheet = Ext.create( "AM.view.master.Default");
		worksheetPanel.add(defaultWorksheet); 
	},
	
	 

	setupFolder : {
		text 			: "Setup", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'User', 
				viewClass:'AM.view.master.User', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'users',
					action : 'index'
				}
				]
			}, 
			{ 
				text:'Customer', 
				viewClass:'AM.view.master.Customer', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'customers',
					action : 'index'
				}
				]
			},
			{ 
				text:'Item Type', 
				viewClass:'AM.view.master.ItemType', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'item_types',
						action : 'index'
					}
				]
			} 
    ]
	},
	
	customerSetupFolder : {
		text 			: "CustomerSetup", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'Item', 
				viewClass:'AM.view.master.Item', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'items',
						action : 'index'
					}
				]
			}, 
    ]
	},
	
	reportFolder : {
		text 			: "Employee Report", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'By Customer', 
				viewClass:'AM.view.master.report.employee.WorkCustomer', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'maintenances',
						action : 'report'
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
			this.setupFolder,
			this.customerSetupFolder,
			// this.inventoryFolder,
			this.reportFolder,
			// this.projectReportFolder
		];
		
		var processList = panel.down('masterProcessList');
		processList.setLoading(true);
	
		var treeStore = processList.getStore();
		treeStore.removeAll(); 
		
		treeStore.setRootNode( this.buildNavigation(currentUser) );
		processList.setLoading(false);
	},
});
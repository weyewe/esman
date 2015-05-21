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
		text 			: "Operation", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'Invoice', 
				viewClass:'AM.view.operation.Invoice', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'invoices',
					action : 'index'
				}
				]
			}, 
     	{ 
				text:'Advanced Payment', 
				viewClass:'AM.view.operation.AdvancedPayment', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'advanced_payments',
					action : 'index'
				}
				]
			}, 
      	{ 
				text:'Monthly Generator', 
				viewClass:'AM.view.operation.MonthlyGenerator', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'monthly_generators',
					action : 'index'
				}
				]
			}, 
      { 
				text:'PaymentRequest', 
				viewClass:'AM.view.operation.PaymentRequest', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'payment_requests',
					action : 'index'
				}
				]
			}, 
			{ 
				text:'DepositDocument', 
				viewClass:'AM.view.operation.DepositDocument', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'deposit_documents',
					action : 'index'
				}
				]
			},  
    ]
	},
  
  financeFolder : {
		text 			: "Finance", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
			{ 
				text:'PaymentVoucher', 
				viewClass:'AM.view.operation.PaymentVoucher', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'payment_vouchers',
					action : 'index'
				}
				]
			}, 
      { 
				text:'ReceiptVoucher', 
				viewClass:'AM.view.operation.ReceiptVoucher', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'receipt_vouchers',
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
      this.financeFolder
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
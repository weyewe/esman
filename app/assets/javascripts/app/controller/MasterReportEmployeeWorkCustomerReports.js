Ext.define('AM.controller.MasterReportEmployeeWorkCustomerReports', {
  extend: 'Ext.app.Controller',

  // stores: ['Incomes'],
  // models: ['Income'],

  views: [
    'master.report.employee.WorkCustomer',
		'report.workcustomer.List',
		'master.report.UserList',
		'Viewport'
  ],

	refs: [
		{
			ref: 'list',
			selector: 'workcustomerList'
		},
		{
			ref: 'recordList',
			selector: 'masterreportemployeeWorkCustomerReport masterreportuserList'
		},
		{
			ref: 'viewport',
			selector: 'vp'
		},
		{
			ref : 'report',
			selector : 'masterreportemployeeWorkCustomerReport'
		} 
	],

  init: function() {
 		console.log("init controller for master.employee.WorkCustomerReports");
	
    this.control({
      'masterreportemployeeWorkCustomerReport chartInspect': {
        'chartLoaded': this.clearList ,
				'seriesClicked' : this.updateList,
				'activate' : this.onActivePanel,
				'afterrender' : this.onAfterRender,
				'destroy' : this.onDestroy,
				'beforedestroy' : this.onBeforeDestroy,
				'beforerender': this.onBeforeRender
      } ,
      'masterreportemployeeWorkCustomerReport masterreportuserList': {
        selectionchange: this.recordSelectionChange,
				afterrender : this.loadRecordList,
      },
		
    });
  },

	loadRecordList: function(){
		var recordList = this.getRecordList();
		recordList.store.load();
	},
	
	recordSelectionChange: function(record){
		console.log("WorkCustomerReports#recordSelectionChange")
		var recordList = this.getRecordList(); 
		var report = this.getReport();
		if (recordList.getSelectionModel().hasSelection()) {
			var row = recordList.getSelectionModel().getSelection()[0];
			var id = row.get("id");
			var chartInspect = report.down('chartInspect');
			console.log("The selected id: " + id);
			chartInspect.selectedParentRecordId = id ;
			chartInspect.parentRecordType = 'user';
			chartInspect.viewer = 'master';
			chartInspect.loadStore();
		}
		// var report = this.getWorkCustomerReport();
		// report.loadStore();
	},

	onBeforeRender: function(panel ){
		// console.log("onBeforeRender");
		// panel.buildChartAndList();
		var list = this.getList(); 
		list.store.loadData([],false);
	},

	clearList: function(){
		var list = this.getList(); 
		list.store.loadData([],false);
		list.setTitle('');
		
	},
	
	updateList: function(clickedPoint, viewType, chart){
		var list = this.getList(); 
		
		var recordName = clickedPoint.value[0];
		
		result = chart.store1.queryBy(function(record){
			return record.get("name") === recordName;
		})
		 
		if( result.length === 0 ){
			Ext.Msg.alert("Error", "No series selected");
			return
		}
		 
		
		var viewValue = 0;
		if( viewType === 'month'){
			viewValue = 1;
		}
		
		var selectedParentRecordId = null;
		var recordList = this.getRecordList();  
		if (recordList.getSelectionModel().hasSelection()) {
			var row = recordList.getSelectionModel().getSelection()[0];
			var id = row.get("id"); 
			selectedParentRecordId = id ; 
		}
		
		var viewport = this.getViewport();
		
		console.log("currentFocusDate:");
		console.log( Ext.Date.format( chart.currentFocusDate, 'Y-m-d H:i:s') );
		list.store.getProxy().extraParams = {
		    viewValue : viewValue,  // for the date 
				selectedRecordId: result.items[0].get('id'), // for the perspective's object id 
				perspective: 'project',
				viewer: 'master',
				selectedParentRecordId: selectedParentRecordId,
				parentRecordType : 'user',
				companyView : false,
				focusDate :  Ext.Date.format( chart.currentFocusDate, 'Y-m-d H:i:s'),
		};
		
		
		viewport.setLoading(true);
		list.store.load({
			callback : function(records, options, success){
				list.setTitle(recordName );
				viewport.setLoading(false);
			}
		});
		
	},
	
	onActivePanel: function(){
	},
	
	onAfterRender: function(panel){
		var list = this.getList(); 
		list.store.loadData([],false);
		
		var recordList = this.getRecordList();
		recordList.store.load();
	},
	
	
	onDestroy: function(){
	},
	
	onBeforeDestroy: function(){
		var list = this.getList(); 
		list.store.getProxy().extraParams = {};
		
	},

});

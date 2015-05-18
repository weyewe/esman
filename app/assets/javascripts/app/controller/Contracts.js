Ext.define('AM.controller.Contracts', {
  extend: 'Ext.app.Controller',

  stores: ['Contracts', 'Customers', 'ContractItems'],
  models: ['Contract'],

  views: [
    'master.contract.List',
		'master.Contract',
		'master.CustomerList'
  ],

  	refs: [
		{
			ref : "wrapper",
			selector : "contractProcess"
		},
		{
			ref : 'parentList',
			selector : 'contractProcess mastercustomerList'
		},
		{
			ref: 'list',
			selector: 'contractlist'
		},
		
		{
			ref: 'contractItemList',
			selector: 'contractitemlist'
		},
		{
			ref : 'searchField',
			selector: 'contractlist textfield[name=searchField]'
		},
		

	],

  init: function() {
    this.control({
			'contractProcess mastercustomerList' : {
				afterrender : this.loadParentObjectList,
				selectionchange: this.parentSelectionChange,
			},
	
      'contractlist': {
        // itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				destroy : this.onDestroy
				// afterrender : this.loadObjectList,
      },
      // 'contractform button[action=save]': {
      //   click: this.updateObject
      // },

// we need to add the execution as well
      'contractlist button[action=collectObject]': {
        click: this.collectObject
      },
      'contractlist button[action=confirmObject]': {
        click: this.confirmObject
      },
      
			'contractProcess mastercustomerList textfield[name=searchField]': {
        change: this.liveSearch
      },

			'contractlist button[action=addObject]': {
        click: this.addObject
			}	,
			
			'contractlist button[action=editObject]': {
        click: this.editObject
      },
			
			'contractform button[action=save]': {
        click: this.updateObject
      },

			'contractlist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			  
			
			
			// related to the savings entry
			
			'contractitemlist': {
        // itemdblclick: this.editObject,
        selectionchange: this.contractItemGridSelectionChange 
      },


			'contractitemlist button[action=addObject]': {
	      click: this.addSavingsObject
	    },
	
			'contractitemform button[action=save]': {
        click: this.updateSavingsObject
      },

	    'contractitemlist button[action=editObject]': {
	      click: this.editSavingsObject
	    },
	    'contractitemlist button[action=deleteObject]': {
	      click: this.deleteSavingsObject
	    },
    });
  },

	deleteObject: function() {
    var record = this.getList().getSelectedObject();

    if (record) {
      var store = this.getContractsStore();
      store.remove(record);
      store.sync();
// to do refresh programmatically
			this.getList().query('pagingtoolbar')[0].doRefresh();
			
			// childList.getStore().loadData([], false);
			
			
    }

  },

	onDestroy: function(){
		// console.log("on Destroy the savings_entries list ");
		this.getContractsStore().loadData([],false);
	},

	liveSearch : function(grid, newValue, oldValue, options){
		// console.log("This is the live search from WeeklyCollectios");
		var me = this;

		me.getCustomersStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getCustomersStore().load();
	},
 

	loadObjectList : function(me){
		me.getStore().load();
	},
	
	loadParentObjectList: function(me){
		// console.log("after render the group_loan list");
		me.getStore().getProxy().extraParams = {};
		me.getStore().load(); 
	},

  

	contractItemGridSelectionChange : function( selectionModel, selections){
		var grid = this.getList();
		var contractItemGrid = this.getContractItemList();
		
		// if( contractItemGrid ){
		// 	console.log( contractItemGrid);
		// 	alert("The savings grid is here");
		// } 
  
    if (selections.length > 0) {
			contractItemGrid.enableRecordButtons();
    } else {
			contractItemGrid.disableRecordButtons();
    }

		 
	},
	
	addObject: function() {
	
    // console.log("Inside the add object");
		var parentObject  = this.getParentList().getSelectedObject();
		if( parentObject) {
			var view = Ext.widget('contractform');
			view.show();
			view.setParentData(parentObject);
		}
  },

	updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');
		var parentList = this.getParentList();
		var list = this.getList();
		var wrapper = this.getWrapper();
		var childList = this.getContractItemList();

    var store = this.getContractsStore();
    var record = form.getRecord();
    var values = form.getValues();

		
		if( record ){
			record.set( values );
			 
			form.setLoading(true);
			record.save({
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					
					// store.getProxy().extraParams = {
					//     livesearch: ''
					// };
	 
					store.load({
						params: {
							parent_id : wrapper.selectedParentId 
						}
					});
					 
					list.enableAddButton();
				 
					
					if (parentList.getSelectionModel().hasSelection()) {

						childList.getStore().loadData([], false);
						var row = parentList.getSelectionModel().getSelection()[0];
						var id = row.get("id"); 
 
						childList.setTitle( "" );

						wrapper.selectedParentId = id ; 

						// empty out the contractItemGrid
					}
					
					
					win.close();
				},
				failure : function(record,op ){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.Contract( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
	
					store.load({
						params: {
							parent_id : wrapper.selectedParentId 
						}
					});
					
					form.setLoading(false);
					win.close();
					
				},
				failure: function( record, op){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
		} 
  },


	editObject: function() {
		var me = this; 
		var parentObject  = this.getParentList().getSelectedObject();
		if( parentObject) {
			
			var record = me.getList().getSelectedObject();
	    var view = Ext.widget('contractform');
	    view.down('form').loadRecord(record);
			view.setComboBoxData( record );
			view.setParentData(parentObject);
			
		}
		 
    
  },

  selectionChange: function(selectionModel, selections) {
		// alert("Selection change on the group loan weekly colelction");
		
		
    var grid = this.getList();
		var contractItemGrid = this.getContractItemList();
		
		// if( contractItemGrid ){
		// 	console.log( contractItemGrid);
		// 	alert("The savings grid is here");
		// } 
  
    if (selections.length > 0) {
      grid.enableRecordButtons();
			grid.enableAddButton();
			contractItemGrid.addObjectButton.enable(); 
    } else {
      grid.disableRecordButtons();
			grid.disableAddButton();
			contractItemGrid.addObjectButton.disable(); 
    }

		var selectedListId; 

		if (grid.getSelectionModel().hasSelection()) {
			 
			var row = grid.getSelectionModel().getSelection()[0];
			selectedListId = row.get("id"); 
			
			var title = "";
			if( row ){
				title = "Contract: " + row.get("code");
			}else{
				title = "";
			}
			contractItemGrid.setTitle( title );
		}
		
		contractItemGrid.getStore().getProxy().extraParams.parent_id =  selectedListId ;
		contractItemGrid.getStore().load();
		
		
  },

	parentSelectionChange: function(selectionModel, selections) {
		var me = this; 
    var grid = me.getList();
		var parentList = me.getParentList();
		var wrapper = me.getWrapper();
		var contractItemGrid = this.getContractItemList(); 
		
		if (selections.length > 0) {
      grid.enableAddButton(); 
    } else {
      grid.disableAddButton(); 
    }
		
		
	 
		 
		if (parentList.getSelectionModel().hasSelection()) {
			
			contractItemGrid.getStore().loadData([], false);
			var row = parentList.getSelectionModel().getSelection()[0];
			var id = row.get("id"); 
			
			var title = "";
			if( row ){
				title = "Customer: " + row.get("name");
			}else{
				title = "";
			}
			grid.setTitle( title );
			
			wrapper.selectedParentId = id ; 
			
			// empty out the contractItemGrid
		}
		
		grid.getStore().getProxy().extraParams.parent_id =  wrapper.selectedParentId ;
		grid.getStore().load(); 
		
		contractItemGrid.setTitle("");
  },

	collectObject: function(){
		var view = Ext.widget('collectcontractform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
		// this.reloadRecordView( record, view ) ; 
	},
	
	executeCollect: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getContractsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'collected_at' , values['collected_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					collect: true 
				},
				success : function(record){
					form.setLoading(false);
					
					me.reloadRecord( record ) ; 
					
					
					win.close();
				},
				failure : function(record,op ){
					// console.log("Fail update");
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					record.reject(); 
					// this.reject(); 
				}
			});
		}
	},
	
	confirmObject: function(){
		var view = Ext.widget('confirmcontractform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
		// this.reloadRecordView( record, view ) ; 
	},
	
	executeConfirm: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getContractsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'confirmed_at' , values['confirmed_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					confirm: true 
				},
				success : function(record){
					form.setLoading(false);
					
					me.reloadRecord( record ) ; 
					store.load();
					
					win.close();
				},
				failure : function(record,op ){
					// console.log("Fail update");
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					record.reject(); 
					// this.reject(); 
				}
			});
		}
	},
	
	reloadRecord: function(record){
		// console.log("Inside reload record");
		// console.log( record );
		var list = this.getList();
		var store = this.getList().getStore();
		var modifiedId = record.get('id');
		
		AM.model.Contract.load( modifiedId , {
		    scope: list,
		    failure: function(record, master) {
		        //do something if the load failed
		    },
		    success: function(record, master) {
			
					recToUpdate = store.getById(modifiedId);
					recToUpdate.set(record.getData());
					recToUpdate.commit();
					list.getView().refreshNode(store.indexOfId(modifiedId));
		    },
		    callback: function(record, master) {
		        //do something whether the load succeeded or failed
		    }
		});
	},
	
	
	
	/*
	FOR THE SAVINGS
	*/
	
	addSavingsObject: function() {
	 
		var parentObject  = this.getList().getSelectedObject();
		console.log("The parent object:");
		console.log( parentObject );
		 
		if( parentObject) { 
			var view = Ext.widget('contractitemform');
			 
			// view.setExtraParamForJsonRemoteStore( parentObject.get("id")); 
			view.setParentData( parentObject );
			view.show();
		}
  },

  editSavingsObject: function() {
		var me = this; 
		var parentObject  = this.getList().getSelectedObject();
    var record = this.getContractItemList().getSelectedObject();

		
		 
		if( parentObject) { 
		
			// =====
			var view = Ext.widget('contractitemform');
			 
			view.down('form').loadRecord(record);
			// view.setExtraParamForJsonRemoteStore( parentObject.get("id")); 
			view.setParentData( parentObject );
			view.setComboBoxData( record );
			view.show();
		}
		
		 
  },

  updateSavingsObject: function(button) {
		console.log("Inside this updateSavingsObject");
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');
		var parentList = this.getParentList();
		
		var groupLoanWeeklyCollectionId = this.getList().getSelectedObject().get("id");
		var wrapper = this.getWrapper();

    var store = this.getContractItemsStore();
    var record = form.getRecord();
    var values = form.getValues();

// console.log("The values: " ) ;
// console.log( values );

		
		if( record ){
			record.set( values );
			 
			form.setLoading(true);
			record.save({
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					
					// store.getProxy().extraParams = {
					//     livesearch: ''
					// };
	 
					store.load({
						params: {
							parent_id : groupLoanWeeklyCollectionId
						}
					});
					 
					
					win.close();
				},
				failure : function(record,op ){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.ContractItem( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
	
					store.load({
						params: {
							parent_id : groupLoanWeeklyCollectionId
						}
					});
					
					form.setLoading(false);
					win.close();
					
				},
				failure: function( record, op){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
		} 
  },

  deleteSavingsObject: function() {
    var record = this.getContractItemList().getSelectedObject();

		

    if (record) {
			var contract_maintenance_id = record.get('contract_maintenance_id');
			// console.log("contract maintenance id ");
			// console.log( contract_maintenance_id ) ;
      var store = this.getContractItemList().getStore();
      store.remove(record);
      store.sync();
// to do refresh programmatically

			this.getContractItemList().getStore().getProxy().extraParams.parent_id =  contract_maintenance_id ;


			this.getContractItemList().query('pagingtoolbar')[0].doRefresh();
    }

  },

});

Ext.define('AM.controller.Items', {
  extend: 'Ext.app.Controller',

  stores: ['Customers', 'Items'],
  models: ['Item'],

  views: [
    'master.item.List',
    'master.item.Form',
		'master.Item',
		'master.CustomerList'
  ],

  	refs: [
		{
			ref : "wrapper",
			selector : "itemProcess"
		},
		{
			ref : 'parentList',
			selector : 'itemProcess mastercustomerList'
		},
		{
			ref: 'list',
			selector: 'itemlist'
		},
		{
			ref : 'searchField',
			selector: 'itemlist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
			'itemProcess mastercustomerList' : {
				afterrender : this.loadParentObjectList,
				selectionchange: this.parentSelectionChange,
			},
	
      'itemlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				destroy : this.onDestroy
				// afterrender : this.loadObjectList,
      },
      'itemform button[action=save]': {
        click: this.updateObject
      },
      'itemlist button[action=addObject]': {
        click: this.addObject
      },
      'itemlist button[action=editObject]': {
        click: this.editObject
      },
      'itemlist button[action=deleteObject]': {
        click: this.deleteObject
      },
			'itemProcess mastercustomerList textfield[name=searchField]': {
        change: this.liveSearch
      },

			'itemlist button[action=deactivateObject]': {
        click: this.deactivateObject
			}	,
			
			'deactivateitemform button[action=confirmDeactivate]' : {
				click : this.executeDeactivate
			},
		
    });
  },
	onDestroy: function(){
		// console.log("on Destroy the savings_entries list ");
		this.getItemsStore().loadData([],false);
	},

	liveSearch : function(grid, newValue, oldValue, options){
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
		console.log("after render from item");
		// console.log("after render the group_loan list");
		me.getStore().getProxy().extraParams =  {};
		me.getStore().load(); 
	},

  addObject: function() {
	
    
		var parentObject  = this.getParentList().getSelectedObject();
		if( parentObject) {
			var view = Ext.widget('itemform');
			view.show();
			view.setParentData(parentObject);
		}
  },

  editObject: function() {
		var me = this; 
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('itemform');

		view.setComboBoxData( record );

		

    view.down('form').loadRecord(record);
  },

  updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');
		var parentList = this.getParentList();
		var wrapper = this.getWrapper();

    var store = this.getItemsStore();
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
							parent_id : wrapper.selectedParentId 
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
			var newObject = new AM.model.Item( values ) ;
			
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

  deleteObject: function() {
    var record = this.getList().getSelectedObject();

    if (record) {
      var store = this.getItemsStore();
      store.remove(record);
      store.sync();
// to do refresh programmatically
			this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();
  
    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  },

	deactivateObject: function(){
		// console.log("mark as Deceased is clicked");
		var view = Ext.widget('deactivateitemform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
		// view.down('form').getForm().findField('c').setValue(record.get('deceased_at')); 
    view.show();
	},
	
	executeDeactivate : function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getItemsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'deactivation_case' , values['deactivation_case'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					deactivate: true 
				},
				success : function(record){
					form.setLoading(false);
					
					// list.fireEvent('confirmed', record);
					
					
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

	parentSelectionChange: function(selectionModel, selections) {
		var me = this; 
    var grid = me.getList();
		var parentList = me.getParentList();
		var wrapper = me.getWrapper();
		
		// console.log("parent selection change");
		// console.log("The wrapper");
		// console.log( wrapper ) ;

    if (selections.length > 0) {
			grid.enableAddButton();
      // grid.enableRecordButtons();
    } else {
			grid.disableAddButton();
      // grid.disableRecordButtons();
    }
		
		 
		if (parentList.getSelectionModel().hasSelection()) {
			var row = parentList.getSelectionModel().getSelection()[0];
			var id = row.get("id"); 
			wrapper.selectedParentId = id ; 
		}
		
		
		
		// console.log("The parent ID: "+ wrapper.selectedParentId );
		
		// grid.setLoading(true); 
		grid.getStore().getProxy().extraParams.parent_id =  wrapper.selectedParentId ;
		grid.getStore().load(); 
  },

});

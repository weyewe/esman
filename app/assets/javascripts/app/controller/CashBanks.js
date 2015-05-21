Ext.define('AM.controller.CashBanks', {
  extend: 'Ext.app.Controller',

  stores: ['CashBanks'],
  models: ['CashBank'],

  views: [
    'master.cashbank.List',
    'master.cashbank.Form'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'cashbanklist'
		} 
	],

  init: function() {
    this.control({
      'cashbanklist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'cashbankform button[action=save]': {
        click: this.updateObject
      },
      'cashbanklist button[action=addObject]': {
        click: this.addObject
      },
      'cashbanklist button[action=editObject]': {
        click: this.editObject
      },
      'cashbanklist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			'cashbanklist textfield[name=searchField]': {
				change: this.liveSearch
			}
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getCashBanksStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getCashBanksStore().load();
	},
 

	loadObjectList : function(me){
		// console.log("************* IN THE USERS CONTROLLER: afterRENDER");
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('cashbankform');
    view.show();
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('cashbankform');

    view.down('form').loadRecord(record);
		view.setComboBoxData(record); 
  },

  updateObject: function(button) {
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getCashBanksStore();
    var record = form.getRecord();
    var values = form.getValues();

    
    
		if( record ){
			record.set( values );
		  form.query('checkbox').forEach(function(checkbox){
      record.set( checkbox['name']  ,checkbox['checked'] ) ;
      });
			form.setLoading(true);
			record.save({
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
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
			var newObject = new AM.model.CashBank( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
      form.query('checkbox').forEach(function(checkbox){
        newObject.set( checkbox['name']  ,checkbox['checked'] ) ;
      });
			newObject.save({
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
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
      var store = this.getCashBanksStore();
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
  }

});

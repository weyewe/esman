Ext.define('AM.controller.Invoices', {
  extend: 'Ext.app.Controller',

  stores: ['Invoices'],
  models: ['Invoice'],

  views: [
    'operation.invoice.List',
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'invoicelist'
		} 
	],

  init: function() {
    this.control({
      'invoicelist': {
        
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
			'invoicelist textfield[name=searchField]': {
				change: this.liveSearch
			} ,
		 
      
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getInvoicesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getInvoicesStore().load();
	},
 

	loadObjectList : function(me){
		// console.log("************* IN THE USERS CONTROLLER: afterRENDER");
		me.getStore().load();
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

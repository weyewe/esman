Ext.define('AM.controller.CashMutations', {
  extend: 'Ext.app.Controller',

  stores: ['CashMutations'],
  models: ['CashMutation'],

  views: [
    'master.cashmutation.List',
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'cashmutationlist'
		} 
	],

  init: function() {
    this.control({
      'cashmutationlist': {
        
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
			'cashmutationlist textfield[name=searchField]': {
				change: this.liveSearch
			} ,
		 
      
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getCashMutationsStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getCashMutationsStore().load();
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

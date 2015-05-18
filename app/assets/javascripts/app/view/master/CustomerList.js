Ext.define('AM.view.master.CustomerList' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.mastercustomerList',

  	store: 'Customers', 
   

	initComponent: function() {
		this.columns = [
		
			{
				xtype : 'templatecolumn',
				text : "Customer",
				flex : 1,
				tpl : '<b>{name}</b>' 
				
			}, 
		];

	 
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});



		this.tbar = [this.searchField ];
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying topics {0} - {1} of {2}',
			emptyMsg: "No topics to display" 
		});

		this.callParent(arguments);
	},
 
	loadMask	: true,
	
	getSelectedObject: function() {
		return this.getSelectionModel().getSelection()[0];
	},

	enableRecordButtons: function() {
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	}
});

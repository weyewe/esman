Ext.define('AM.view.master.cashmutation.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.cashmutationlist',

  	store: 'CashMutations', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Source',  dataIndex: 'source_class', flex: 1},
      { header: 'Source Code',  dataIndex: 'source_code', flex: 1},
      { header: 'CashBank',  dataIndex: 'cash_bank_name', flex: 1},
      { header: 'Amount',  dataIndex: 'amount', flex: 1},
      { header: 'status',  dataIndex: 'status_text', flex: 1},
      {	header: 'Tanggal mutasi', dataIndex: 'mutation_date', flex: 1 } ,
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

	enableRecordButtons: function(record) {				 
	},

	disableRecordButtons: function(record) {	
	}
});


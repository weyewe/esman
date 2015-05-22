Ext.define('AM.view.operation.monthlygeneratorinvoice.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.monthlygeneratorinvoiceList',

  	store: 'MonthlyGeneratorInvoices', 
   

	initComponent: function() {
		this.columns = [
		
		  { header: 'ID', dataIndex: 'id'},
			{ header: 'Code',  dataIndex: 'code', flex: 1},
			{	header: 'Source', dataIndex: 'source_class', flex: 1 } ,
      {	header: 'Source Code', dataIndex: 'source_code', flex: 1 } ,
      {	header: 'Home', dataIndex: 'home_name', flex: 1 } ,
      {	header: 'Amount', dataIndex: 'amount', flex: 1 }, 
      {	header: 'Deskripsi', dataIndex: 'description', flex: 1 },
      {	header: 'Tanggal Invoice', dataIndex: 'invoice_date', flex: 1 },
      {	header: 'Due Date', dataIndex: 'due_date', flex: 1 },
      {	header: 'Konfirmasi', dataIndex: 'is_confirmed', flex: 1 },
      {	header: 'Tanggal Konfirmasi', dataIndex: 'confirmed_at', flex: 1 },
		];

	 
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});



// 		this.tbar = [this.searchField ];
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

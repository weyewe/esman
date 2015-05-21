Ext.define('AM.view.operation.invoice.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.invoicelist',

  	store: 'Invoices', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Code',  dataIndex: 'code', flex: 1},
			{	header: 'Source', dataIndex: 'source_class', flex: 1 } ,
      {	header: 'Source Code', dataIndex: 'source_code', flex: 1 } ,
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



		this.tbar = [this.addObjectButton, this.editObjectButton, this.confirmObjectButton,
                 this.unconfirmObjectButton, this.deleteObjectButton, this.searchField ];
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
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
    this.confirmObjectButton.enable();
    this.unconfirmObjectButton.enable();
    
    selectedObject = this.getSelectedObject();
		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show();
		}else{
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		}
		 
	},

	disableRecordButtons: function(record) {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
    this.confirmObjectButton.disable();
    this.unconfirmObjectButton.disable();
	}
});

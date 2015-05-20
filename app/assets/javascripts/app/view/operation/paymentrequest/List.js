Ext.define('AM.view.operation.paymentrequest.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.paymentrequestlist',

  	store: 'PaymentRequests', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Code',  dataIndex: 'code', flex: 1},
			{	header: 'Vendor', dataIndex: 'vendor_name', flex: 1 } ,
      {	header: 'Amount', dataIndex: 'amount', flex: 1 }, 
      {	header: 'Deskripsi', dataIndex: 'description', flex: 1 },
      {	header: 'Tanggal Request', dataIndex: 'request_date', flex: 1 },
      {	header: 'Konfirmasi', dataIndex: 'is_confirmed', flex: 1 },
      {	header: 'Tanggal Konfirmasi', dataIndex: 'confirmed_at', flex: 1 },
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add Payment Request',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit Payment Request',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete Payment Request',
			action: 'deleteObject',
			disabled: true
		});
		
    this.confirmObjectButton = new Ext.Button({
			text: 'Confirm Payment Request',
			action: 'confirmObject',
			disabled: true
		});
    
    this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm Payment Request',
			action: 'unconfirmObject',
			disabled: true,
      hidden : true 
		});
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

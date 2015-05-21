Ext.define('AM.view.operation.paymentvoucher.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.paymentvoucherlist',

  	store: 'PaymentVouchers',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
      
      { header: 'Code',  dataIndex: 'code', flex: 1},
			{ header: 'Vendor',  dataIndex: 'vendor_name', flex: 1},
      { header: 'CashBank',  dataIndex: 'cash_bank_name', flex: 1},
			{	header: 'Total Amount', dataIndex: 'amount', flex: 1 },
		  {	header: 'Tanggal Pembayaran', dataIndex: 'payment_date', flex: 1 },    
			{	header: 'Deskripsi', dataIndex: 'description', flex: 1 },
		  {	header: 'Konfirmasi', dataIndex: 'is_confirmed', flex: 1 },
      {	header: 'Tanggal Konfirmasi', dataIndex: 'confirmed_at', flex: 1 },
			
			
 
// 			{
// 				xtype : 'templatecolumn',
// 				text : "Transaksi",
// 				flex : 3,
// 				tpl : 'Tanggal Transaksi: <b>{transaction_datetime}</b>' + '<br />' + '<br />' +
// 							'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
// 							'Tanggal Konfirmasi: <b>{confirmed_at}</b>' 
// 			},
			
			
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete',
			action: 'deleteObject',
			disabled: true
		});
		
		this.confirmObjectButton = new Ext.Button({
			text: 'Confirm',
			action: 'confirmObject',
			disabled: true
		});
	
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm',
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
		
		 
			this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton , 
				'-',
					this.confirmObjectButton, this.unconfirmObjectButton,
					'->',
					this.searchField ];
	 


		
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
		
		selectedObject = this.getSelectedObject();
		
		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show();
			this.unconfirmObjectButton.enable();
		}else{
			this.confirmObjectButton.enable();
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		}
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.confirmObjectButton.disable(); 
	}
});

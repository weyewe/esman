Ext.define('AM.view.operation.depositdocument.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.depositdocumentlist',

  	store: 'DepositDocuments', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Code',  dataIndex: 'code', flex: 1},
      { header: 'User',  dataIndex: 'user_name', flex: 1},
			{	header: 'Home', dataIndex: 'home_name', flex: 1 } ,
      {	header: 'Amount Deposit', dataIndex: 'amount_deposit', flex: 1 }, 
      {	header: 'Amount Charge', dataIndex: 'amount_charge', flex: 1 }, 
      {	header: 'Deskripsi', dataIndex: 'description', flex: 1 },
      {	header: 'Tanggal Deposit', dataIndex: 'deposit_date', flex: 1 },
      {	header: 'Konfirmasi', dataIndex: 'is_confirmed', flex: 1 },
      {	header: 'Tanggal Konfirmasi', dataIndex: 'confirmed_at', flex: 1 },
      {	header: 'Finish', dataIndex: 'is_finished', flex: 1 },
      {	header: 'Tanggal Finish', dataIndex: 'finished_at', flex: 1 },
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add DepositDocument',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit DepositDocument',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete DepositDocument',
			action: 'deleteObject',
			disabled: true
		});
		
    this.confirmObjectButton = new Ext.Button({
			text: 'Confirm DepositDocument',
			action: 'confirmObject',
			disabled: true
		});
    
    this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm DepositDocument',
			action: 'unconfirmObject',
			disabled: true,
      hidden : true 
		});
    
    
     this.finishObjectButton = new Ext.Button({
			text: 'Finish DepositDocument',
			action: 'finishObject',
			disabled: true
		});
    
    this.unfinishObjectButton = new Ext.Button({
			text: 'Unfinish DepositDocument',
			action: 'unfinishObject',
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
                 this.unconfirmObjectButton, this.finishObjectButton,, this.unfinishObjectButton,
                 this.deleteObjectButton, this.searchField ];
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
    this.finishObjectButton.enable();
    this.unfinishObjectButton.enable();
    selectedObject = this.getSelectedObject();
		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show();
		}else{
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		}
    
    if( selectedObject && selectedObject.get("is_finished") == true ){
			this.finishObjectButton.hide();
			this.unfinishObjectButton.show();
		}else{
			this.finishObjectButton.show();
			this.unfinishObjectButton.hide();
		}
		 
	},

	disableRecordButtons: function(record) {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
    this.confirmObjectButton.disable();
    this.unconfirmObjectButton.disable();
    this.finishObjectButton.disable();
    this.unfinishObjectButton.disable();
	}
});

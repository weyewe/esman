Ext.define('AM.view.operation.receiptvoucher.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.receiptvoucherform',

  title : 'Add / Edit ReceiptVoucher ',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 
    var me = this; 
	 
		var remoteJsonStoreType = Ext.create(Ext.data.JsonStore, {
			storeId : 'type_search',
			fields	: [
			 		{
						name : 'user_name',
						mapping : "name"
					} ,
					{
						name : 'user_id',
						mapping : "id"
					}  
			], 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_user',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
    
		
    var remoteJsonStoreCashBank = Ext.create(Ext.data.JsonStore, {
			storeId : 'type_search',
			fields	: [
			 		{
						name : 'cash_bank_name',
						mapping : "name"
					} ,
					{
						name : 'cash_bank_id',
						mapping : "id"
					}  
			], 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_cash_bank',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
    
    var remoteJsonStoreReceivable = Ext.create(Ext.data.JsonStore, {
			storeId : 'type_search',
			fields	: [
			 		{
						name : 'receivable_source_code',
						mapping : "source_code"
					} ,
        	{
						name : 'receivable_amount',
						mapping : "amount"
					} ,
					{
						name : 'receivable_id',
						mapping : "id"
					}  
			], 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_receivable',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
    
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '100%'
      },
      items: [
				{
	        xtype: 'hidden',
	        name : 'id',
	        fieldLabel: 'id'
	      },
				{
	        xtype: 'displayfield',
	        name : 'code',
	        fieldLabel: 'Code'
	      },
				
       {
					fieldLabel: 'User',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'user_name',
					valueField : 'user_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{user_name}">' + 
													'<div class="combo-name">{user_name}</div>' + 
							 					'</div>';
						}
					},
					name : 'user_id' 
				},
        {
					fieldLabel: 'CashBank',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'cash_bank_name',
					valueField : 'cash_bank_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreCashBank , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{cash_bank_name}">' + 
													'<div class="combo-name">{cash_bank_name}</div>' + 
							 					'</div>';
						}
					},
					name : 'cash_bank_id' 
				},
         {
					fieldLabel: 'Receivable',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'receivable_source_code',
					valueField : 'receivable_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreReceivable , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{receivable_source_code}">' + 
													'<div class="combo-name">{receivable_source_code}</div>' + 
                          '<div class="combo-name">{receivable_amount}</div>' +
							 					'</div>';
						}
					},
					name : 'receivable_id' 
				},
       {
					xtype: 'datefield',
					name : 'receipt_date',
					fieldLabel: 'Tanggal Terima',
					format: 'Y-m-d',
				},
        {
					xtype: 'textarea',
					name : 'description',
					fieldLabel: 'Description'
				}
        
			]
    }];

    this.buttons = [{
      text: 'Save',
      action: 'save'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setSelectedType: function( user_id ){
		var comboBox = this.down('form').getForm().findField('user_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : user_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( user_id );
			}
		});
	},

  setSelectedCashBank: function( cash_bank_id ){
		var comboBox = this.down('form').getForm().findField('cash_bank_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : cash_bank_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( cash_bank_id );
			}
		});
	},
  
  setSelectedReceivable: function( receivable_id ){
		var comboBox = this.down('form').getForm().findField('receivable_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : receivable_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( receivable_id );
			}
		});
	},
  
	setComboBoxData : function( record){		
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedType( record.get("user_id")  ) ; 
    me.setSelectedCashBank( record.get("cash_bank_id")  ) ; 
    me.setSelectedReceivable( record.get("receivable_id")  ) ; 
	},
});


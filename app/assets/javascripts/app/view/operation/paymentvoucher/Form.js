
Ext.define('AM.view.operation.paymentvoucher.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.paymentvoucherform',

  title : 'Add / Edit PaymentVoucher',
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
						name : 'vendor_name',
						mapping : "name"
					} ,
					{
						name : 'vendor_id',
						mapping : "id"
					}  
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_vendor',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
    
	 var remoteJsonStoreType2 = Ext.create(Ext.data.JsonStore, {
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
	      },{
		        xtype: 'displayfield',
		        name : 'code',
		        fieldLabel: 'Kode'
		    },{
					xtype: 'datefield',
					name : 'payment_date',
					fieldLabel: 'Tanggal Transaksi',
					format: 'Y-m-d',
				},{
					fieldLabel: 'Vendor',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'vendor_name',
					valueField : 'vendor_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{vendor_name}">' + 
													'<div class="combo-name">{vendor_name}</div>' + 
							 					'</div>';
						}
					},
					name : 'vendor_id' 
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
					store : remoteJsonStoreType2 , 
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
	        xtype: 'textarea',
	        name : 'description',
	        fieldLabel: 'Deskripsi'
	      },
			
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
  
  
  setSelectedAccount: function( cash_bank_id ){
		// console.log("inside set selected original account id ");
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
  
  setSelectedVendor: function( vendor_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('vendor_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : vendor_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( vendor_id );
			}
		});
	},
  setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedAccount( record.get("cash_bank_id")  ) ; 
    me.setSelectedVendor( record.get("vendor_id")  ) ; 
	},
  
 
});





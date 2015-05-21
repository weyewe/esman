
Ext.define('AM.view.operation.paymentvoucherdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.paymentvoucherdetailform',

  title : 'Add / Edit Paymentvoucher Detail',
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
						name : 'payable_source_code',
						mapping : "source_code"
					} ,
          {
						name : 'payable_amount',
						mapping : "amount"
					} ,
					{
						name : 'payable_id',
						mapping : "id"
					}  
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_payable',
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
	        xtype: 'hidden',
	        name : 'payment_voucher_id',
	        fieldLabel: 'payment_voucher_id'
	      },{
		      xtype: 'displayfield',
	        name : 'paymentvoucher_code',
	        fieldLabel: 'Kode Paymentvoucher'
		    },
				{
					fieldLabel: 'PaymentRequest',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'payable_source_code',
					valueField : 'payable_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{payable_id}">' + 
													'<div class="combo-name">{payable_source_code}</div>' +
                          '<div class="combo-name">{payable_amount}</div>' + 
							 					'</div>';
						}
					},
					name : 'payable_id' 
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

	setSelectedAccount: function( account_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('payable_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : account_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( payable_id );
			}
		});
	},
	
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedAccount( record.get("account_id")  ) ; 
	},
	
	setParentData: function( record) {
		this.down('form').getForm().findField('paymentvoucher_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('payment_voucher_id').setValue(record.get('id'));
	}
 
});





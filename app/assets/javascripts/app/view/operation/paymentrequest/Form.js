Ext.define('AM.view.operation.paymentrequest.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.paymentrequestform',

  title : 'Add / Edit PaymentRequest ',
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
					xtype: 'textfield',
					name : 'amount',
					fieldLabel: 'Amount'
				},
       {
					xtype: 'datefield',
					name : 'request_date',
					fieldLabel: 'Tanggal Request',
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

	setSelectedType: function( vendor_id ){
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
		console.log("gonna set combo box data");
		var me = this; 
		me.setLoading(true);
    
    console.log( record.get("vendor_id"));
		
		me.setSelectedType( record.get("vendor_id")  ) ; 
	},
});


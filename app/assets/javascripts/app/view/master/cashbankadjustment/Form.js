Ext.define('AM.view.master.cashbankadjustment.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.cashbankadjustmentform',

  title : 'Add / Edit CashBankAdjustment',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 
    var localJsonStoreStatus = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'status_selector',
			fields	: [ 
				{ name : "status"}, 
				{ name : "status_text"}  
			], 
			data : [
				{ status : 1, status_text : "Penambahan"},
				{ status : 2, status_text : "Pengurangan"},
			] 
		});
		
    var remoteJsonStoreType = Ext.create(Ext.data.JsonStore, {
			storeId : 'type_search',
			fields	: [
			 		{
						name : 'cash_bank_name',
						mapping : "name"
					} ,
					{
						name : 'cash_bank_id',
						mapping : "id"
					}  ,
          {
						name : 'cash_bank_amount',
						mapping : "amount"
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
					store : remoteJsonStoreType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{cash_bank_name}">' + 
													'<div class="combo-name">{cash_bank_name}</div>' + 
                          '<div class="combo-name">{cash_bank_amount}</div>'
							 					'</div>';
						}
					},
					name : 'cash_bank_id' 
				},
       
        {
					xtype: 'numberfield',
					name : 'amount',
					fieldLabel: 'Amount'
				},
        {
					fieldLabel: 'Status',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'status_text',
					valueField : 'status',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreStatus,
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{status_text}">' +  
													'<div class="combo-name">{status_text}</div>' +
							 					'</div>';
						}
					},
					name : 'status' 
				},
        {
					xtype: 'datefield',
					name : 'adjustment_date',
					fieldLabel: 'Tanggal Adjust',
					format: 'Y-m-d',
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

  setSelectedType: function( cash_bank_id ){
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

   setSelectedStatus: function( status ){
      var comboBox = this.down('form').getForm().findField('status'); 
      var me = this; 
      var store = comboBox.store;  
      store.load({
        params: {
          selected_id : status 
        },
        callback : function(records, options, success){
          me.setLoading(false);
          comboBox.setValue( status );
        }
      });
    },
  
	setComboBoxData : function( record){
		
		var me = this; 
		me.setLoading(true);
    
    console.log( record.get("status"));
		me.setSelectedStatus( record.get("status")  ) ; 
		me.setSelectedType( record.get("cash_bank_id")  ) ; 
  }
});


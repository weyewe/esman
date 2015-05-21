Ext.define('AM.view.master.cashbankmutation.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.cashbankmutationform',

  title : 'Add / Edit CashBankMutation',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 
   
		
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
	        xtype: 'displayfield',
	        name : 'code',
	        fieldLabel: 'Code'
	      },
				{
					fieldLabel: 'Source CashBank',
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
                          '<div class="combo-name">{cash_bank_amount}</div>'
							 					'</div>';
						}
					},
					name : 'source_cash_bank_id' 
				},
        {
					fieldLabel: 'Target CashBank',
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
					name : 'target_cash_bank_id' 
				},,
       
        {
					xtype: 'numberfield',
					name : 'amount',
					fieldLabel: 'Amount'
				},
        {
					xtype: 'datefield',
					name : 'mutation_date',
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

  setSelectedType: function( source_cash_bank_id ){
      var comboBox = this.down('form').getForm().findField('source_cash_bank_id'); 
      var me = this; 
      var store = comboBox.store;  
      store.load({
        params: {
          selected_id : source_cash_bank_id 
        },
        callback : function(records, options, success){
          me.setLoading(false);
          comboBox.setValue( source_cash_bank_id );
        }
      });
    },

   setSelectedStatus: function( target_cash_bank_id ){
      var comboBox = this.down('form').getForm().findField('target_cash_bank_id'); 
      var me = this; 
      var store = comboBox.store;  
      store.load({
        params: {
          selected_id : target_cash_bank_id 
        },
        callback : function(records, options, success){
          me.setLoading(false);
          comboBox.setValue( target_cash_bank_id );
        }
      });
    },
  
	setComboBoxData : function( record){
		
		var me = this; 
		me.setLoading(true);
    
    console.log( record.get("status"));
		me.setSelectedStatus( record.get("target_cash_bank_id")  ) ; 
		me.setSelectedType( record.get("source_cash_bank_id")  ) ; 
  }
});


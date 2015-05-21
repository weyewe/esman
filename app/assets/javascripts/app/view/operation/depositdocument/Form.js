Ext.define('AM.view.operation.depositdocument.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.depositdocumentform',

  title : 'Add / Edit DepositDocument ',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 
    var me = this; 
	 
		var remoteJsonStoreHome = Ext.create(Ext.data.JsonStore, {
			storeId : 'home_search',
			fields	: [
			 		{
						name : 'home_name',
						mapping : "name"
					} ,
					{
						name : 'home_id',
						mapping : "id"
					}  
			],				 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_home',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
    
		var remoteJsonStoreUser = Ext.create(Ext.data.JsonStore, {
			storeId : 'user_search',
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
					fieldLabel: 'Home',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'home_name',
					valueField : 'home_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreHome , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{home_name}">' + 
													'<div class="combo-name">{home_name}</div>' + 
							 					'</div>';
						}
					},
					name : 'home_id' 
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
					store : remoteJsonStoreUser , 
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
					xtype: 'numberfield',
					name : 'amount_deposit',
					fieldLabel: 'Amount Deposit'
				},
       {
					xtype: 'datefield',
					name : 'deposit_date',
					fieldLabel: 'Tanggal Deposit',
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

	setSelectedHome: function( home_id ){
		var comboBox = this.down('form').getForm().findField('home_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : home_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( home_id );
			}
		});
	},

  setSelectedUser: function( user_id ){
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
  
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);		
		me.setSelectedUser( record.get("user_id")  ) ; 
    me.setSelectedHome( record.get("home_id")  ) ; 
	},
});


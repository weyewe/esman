Ext.define('AM.view.master.contract.contractitem.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.contractitemform',

  title : 'Add / Edit Contract',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
		var me = this; 
	 
		var remoteJsonStoreItem = Ext.create(Ext.data.JsonStore, {
			storeId : 'item_search',
			fields	: [
			 		{
						name : 'item_type_name',
						mapping : "type_name"
					} ,
					{
						name : 'item_code',
						mapping : "code"
					},
					{
						name : 'item_id',
						mapping : "id"
					} 
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_item',
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
	        name : 'customer_id',
	        fieldLabel: 'Customer ID'
	      },
				{
	        xtype: 'hidden',
	        name : 'contract_maintenance_id',
	        fieldLabel: 'Contract ID'
	      },
	
	
				{
					xtype: 'displayfield',
					fieldLabel: 'Customer',
					name: 'customer_name' ,
					value : '10' 
				},
				
				{
					xtype: 'displayfield',
					fieldLabel: 'Contract',
					name: 'contract_maintenance_code' ,
					value : '10' 
				}, 
				{
					fieldLabel: 'Item',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'item_code',
					valueField : 'item_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreItem , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_code}">' + 
													'<div class="combo-name">{item_type_name}</div>' + 
													'<span>{item_code}</span>' + 
							 					'</div>';
						}
					},
					name : 'item_id' 
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

	
	setSelectedItem: function( item_id ){
		var comboBox = this.down('form').getForm().findField('item_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : item_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( item_id );
			}
		});
	},

	setComboBoxData : function( record){
		// console.log("gonna set combo box data");
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedItem( record.get("item_id")  ) ; 
	},
	
	setParentData: function( record ){
		
		this.down('form').getForm().findField('customer_id').setValue(record.get('customer_id')); 
		this.down('form').getForm().findField('contract_maintenance_id').setValue(record.get('id')); 
		
		this.down('form').getForm().findField('customer_name').setValue(record.get('customer_name')); 
		this.down('form').getForm().findField('contract_maintenance_code').setValue(record.get('code'));
	},
});



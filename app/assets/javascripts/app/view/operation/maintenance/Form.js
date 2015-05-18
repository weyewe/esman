Ext.define('AM.view.operation.maintenance.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.maintenanceform',

  title : 'Add / Edit Maintenance',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
		var localJsonStoreComplaintCase = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'complaint_case_selector',
			fields	: [ 
				{ name : "complaint_case"}, 
				{ name : "complaint_case_text"}  
			], 
			data : [
				{ complaint_case : 1, complaint_case_text : "Scheduled"},
				{ complaint_case : 2, complaint_case_text : "Emergency"}
			] 
		});
		
		var remoteJsonStoreItem = Ext.create(Ext.data.JsonStore, {
			storeId : 'item_search',
			fields	: [
			 		{
						name : 'item_code',
						mapping : "code"
					} ,
					{
						name : 'item_description',
						mapping : "description"
					} ,
					
					{
						name : 'item_id',
						mapping : "id"
					}  ,
					{
						name : 'type_name',
						mapping : "type_name"
					} ,
			],
			
		 
			proxy  	: {
				extraParams : {
					parent_id : null
				},
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
					name : 'customer_name',
					fieldLabel: 'Customer'
				},
				{
					xtype: 'hidden',
					name : 'customer_id',
					fieldLabel: 'Customer Id'
				},
	  
				
				{
	        xtype: 'customdatetimefield',
	        name : 'complaint_date',
	        fieldLabel: ' Waktu complaint',
					dateCfg : {
						format: 'Y-m-d'
					},
					timeCfg : {
						increment : 15
					}
				},
				
				{
					fieldLabel: 'Kasus Complaint',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'complaint_case_text',
					valueField : 'complaint_case',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreComplaintCase, 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{complaint_case_text}">' +  
													'<div class="combo-name">{complaint_case_text}</div>' +
							 					'</div>';
						}
					},
					name : 'complaint_case' 
				},
				
				{
					xtype: 'textarea',
					name : 'complaint',
					fieldLabel: 'Detail Complaint'
				},
				
				{
					fieldLabel: 'Karyawan Pelaksana',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'user_name',
					valueField : 'user_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreUser, 
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
					store : remoteJsonStoreItem, 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_code}">' +  
													'<div class="combo-name">{type_name} | {item_code}</div>' +
													'<div class="combo-name">{item_description}</div>' +
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
	
	
 
	
	
	setComboBoxExtraParams: function( parent_id ) {
		var me =this;
		me.setExtraParamInItemComboBox( parent_id );
	},
	
	
	
	setComboBoxData : function( record){
		// console.log("gonna set combo box data");
		var me = this; 
		me.setLoading(true);
		me.setSelectedItem( record.get("item_id")  ) ; 
		me.setSelectedUser( record.get("user_id")  ) ;
	},
	 
	setParentData: function( record ){
		this.down('form').getForm().findField('customer_name').setValue(record.get('name')); 
		this.down('form').getForm().findField('customer_id').setValue(record.get('id')); 
	},
	
});


Ext.define('AM.view.operation.maintenanceschedule.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.maintenancescheduleform',

  title : 'Add / Edit ',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
	
  initComponent: function() {
	
		var remoteJsonStore = Ext.create(Ext.data.JsonStore, {
			storeId : 'customer_search',
			fields	: [
	 				{
						name : 'customer_id',
						mapping : "id"
					},
					{
						name : 'customer_name',
						mapping : 'name'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_customer',
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
					fieldLabel: ' Customer ',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'customer_name',
					valueField : 'customer_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStore, 
					listConfig : {
						getInnerTpl: function(){
							return '<div data-qtip="{customer_name}">' +  
												'<div class="combo-name">{customer_name}</div>' + 
										 '</div>';
						}
					},
					name : 'customer_id' 
				},
				{
					xtype : 'datefield',
					fieldLabel: "Tanggal Penerimaan",
					name : 'receival_date',
					format: 'd/m/Y'
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

	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		var comboBox = this.down('form').getForm().findField('customer_id'); 
		var selectedRecordId = record.get("customer_id");
		
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : selectedRecordId
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( selectedRecordId );
			}
		});
	}
});


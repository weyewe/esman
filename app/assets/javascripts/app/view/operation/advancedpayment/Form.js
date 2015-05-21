Ext.define('AM.view.operation.advancedpayment.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.advancedpaymentform',

  title : 'Add / Edit AdvancedPayment ',
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
					store : remoteJsonStoreType , 
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
					xtype: 'numberfield',
					name : 'amount',
					fieldLabel: 'Amount'
				},
       {
					xtype: 'datefield',
					name : 'start_date',
					fieldLabel: 'Tanggal Mulai',
					format: 'Y-m-d',
				},
        {
					xtype: 'numberfield',
					name : 'duration',
					fieldLabel: 'Durasi(bulan)'
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

	setSelectedType: function( home_id ){
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

	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);		
		me.setSelectedType( record.get("home_id")  ) ; 
	},
});


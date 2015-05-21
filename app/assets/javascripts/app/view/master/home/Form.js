Ext.define('AM.view.master.home.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.homeform',

  title : 'Add / Edit Home ',
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
						name : 'home_type_name',
						mapping : "name"
					} ,
					{
						name : 'home_type_id',
						mapping : "id"
					}  
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_home_type',
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
	        xtype: 'textfield',
	        name : 'name',
	        fieldLabel: 'Home Name'
	      },
				{
					xtype: 'textarea',
					name : 'address',
					fieldLabel: 'Address'
				},
       {
					fieldLabel: 'Home Type',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'home_type_name',
					valueField : 'home_type_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{home_type_name}">' + 
													'<div class="combo-name">{home_type_name}</div>' + 
							 					'</div>';
						}
					},
					name : 'home_type_id' 
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

	setSelectedType: function( home_type_id ){
		var comboBox = this.down('form').getForm().findField('home_type_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : home_type_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( home_type_id );
			}
		});
	},

	setComboBoxData : function( record){
		console.log("gonna set combo box data");
		var me = this; 
		me.setLoading(true);
    
    console.log( record.get("home_type_id"));
		
		me.setSelectedType( record.get("home_type_id")  ) ; 
	},
});


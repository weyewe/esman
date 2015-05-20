Ext.define('AM.view.master.homeassignment.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.homeassignmentform',

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
	        xtype: 'hidden',
	        name : 'home_id',
	        fieldLabel: 'Home ID'
	      },
				{
					xtype: 'displayfield',
					fieldLabel: 'Home',
					name: 'home_name' ,
					value : '10' 
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
					store : remoteJsonStoreType , 
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
					xtype: 'datefield',
					name : 'assignment_date',
					fieldLabel: 'Tanggal Assignment',
					format: 'Y-m-d',
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

	setSelectedType: function( user_id ){
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
		console.log("gonna set combo box data");
		var me = this; 
		me.setLoading(true);
    
    console.log( record.get("user_id"));
		
		me.setSelectedType( record.get("user_id")  ) ; 
	},
  
  setParentData: function( record ){
		this.down('form').getForm().findField('home_name').setValue(record.get('name')); 
		this.down('form').getForm().findField('home_id').setValue(record.get('id')); 
	},
  
});


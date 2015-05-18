Ext.define('AM.view.master.itemtype.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.itemtypeform',

  title : 'Add / Edit Type',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 
		
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
	        fieldLabel: 'Tipe Item Support'
	      },
				{
					xtype: 'textfield',
					name : 'description',
					fieldLabel: 'Deskripsi'
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
	
		// var role_id = record.get("role_id");
		// var comboBox = this.down('form').getForm().findField('role_id'); 
		// var me = this; 
		// var store = comboBox.store; 
		// store.load({
		// 	params: {
		// 		selected_id : role_id 
		// 	},
		// 	callback : function(records, options, success){
		// 		me.setLoading(false);
		// 		comboBox.setValue( role_id );
		// 	}
		// });
	}
});


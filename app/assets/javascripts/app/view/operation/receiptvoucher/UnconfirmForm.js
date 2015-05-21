Ext.define('AM.view.operation.receiptvoucher.UnconfirmForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.unconfirmreceiptvoucherform',

  title : 'Unconfirm',
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
					xtype: 'displayfield',
					fieldLabel: 'Code ',
					name: 'code' 
				},
		 
				
			]
    }];

    this.buttons = [{
      text: 'Unconfirm',
      action: 'unconfirm'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		this.down('form').getForm().findField('code').setValue(record.get('code')); 
	}
});

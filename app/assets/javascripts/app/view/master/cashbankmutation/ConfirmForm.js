Ext.define('AM.view.master.cashbankmutation.ConfirmForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.confirmcashbankmutationform',

  title : 'Confirm',
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
				  {
					xtype: 'datefield',
					name : 'confirmed_at',
					fieldLabel: 'Tanggal Konfirmasi',
					format: 'Y-m-d',
				},
				
			]
    }];

    this.buttons = [{
      text: 'Confirm',
      action: 'confirm'
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

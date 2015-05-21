Ext.define('AM.view.operation.monthlygenerator.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.monthlygeneratorform',

  title : 'Add / Edit MonthlyGenerator ',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 
    var me = this; 
	   
		
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
					xtype: 'datefield',
					name : 'generated_date',
					fieldLabel: 'Tanggal Start',
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

  	setComboBoxData : function( record){
		var me = this; 
// 		me.setLoading(true);		
// 		me.setSelectedType( record.get("home_id")  ) ; 
	},
});


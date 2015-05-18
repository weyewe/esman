Ext.define('AM.view.master.contract.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.contractform',

  title : 'Add / Edit Contract',
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
	        xtype: 'hidden',
	        name : 'customer_id',
	        fieldLabel: 'Customer ID'
	      },
				{
					xtype: 'displayfield',
					fieldLabel: 'Customer',
					name: 'customer_name' ,
					value : '10' 
				},
				{
					xtype: 'displayfield',
					fieldLabel: 'Code',
					name: 'code' ,
					value : '' 
				},
			 
				
				{
					xtype: 'textfield',
					name : 'name',
					fieldLabel: 'Judul Kontrak'
				},
				{
					xtype: 'textarea',
					name : 'description',
					fieldLabel: 'Deskripsi'
				},
				{
					xtype: 'datefield',
					name : 'started_at',
					fieldLabel: 'Kontrak Mulai',
					format: 'Y-m-d',
				},
				{
					xtype: 'datefield',
					name : 'finished_at',
					fieldLabel: 'Kontrak Selesai',
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

	// 
	// setSelectedType: function( type_id ){
	// 	var comboBox = this.down('form').getForm().findField('type_id'); 
	// 	var me = this; 
	// 	var store = comboBox.store;  
	// 	store.load({
	// 		params: {
	// 			selected_id : type_id 
	// 		},
	// 		callback : function(records, options, success){
	// 			me.setLoading(false);
	// 			comboBox.setValue( type_id );
	// 		}
	// 	});
	// },

	setComboBoxData : function( record){
		// console.log("gonna set combo box data");
		// var me = this; 
		// me.setLoading(true);
		
		// me.setSelectedType( record.get("type_id")  ) ; 
	},
	
	setParentData: function( record ){
		this.down('form').getForm().findField('customer_name').setValue(record.get('name')); 
		this.down('form').getForm().findField('customer_id').setValue(record.get('id')); 
	},
});


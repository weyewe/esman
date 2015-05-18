Ext.define('AM.view.operation.maintenance.DiagnoseForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.diagnosemaintenanceform',

  title : 'Diagnose',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
		var localJsonStoreDiagnosisCase = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'diagnosis_case_selector',
			fields	: [ 
				{ name : "diagnosis_case"}, 
				{ name : "diagnosis_case_text"}  
			], 
			data : [
				{ diagnosis_case : 1, diagnosis_case_text : "OK"},
				{ diagnosis_case : 2, diagnosis_case_text : "Butuh Perbaikan"},
				{ diagnosis_case : 3, diagnosis_case_text : "Butuh Penggantian"}
			] 
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
					xtype: 'displayfield',
					fieldLabel: 'Maintenance ',
					name: 'code' 
				},
			 
				{
					xtype: 'displayfield',
					fieldLabel: 'Item',
					name: 'item_code' 
				},
		 
				{
	        xtype: 'customdatetimefield',
	        name : 'diagnosis_date',
	        fieldLabel: ' Waktu complaint',
					dateCfg : {
						format: 'Y-m-d'
					},
					timeCfg : {
						increment : 15
					}
				},
				
				{
					fieldLabel: 'Kasus Diagnosa',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'diagnosis_case_text',
					valueField : 'diagnosis_case',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreDiagnosisCase, 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{diagnosis_case_text}">' +  
													'<div class="combo-name">{diagnosis_case_text}</div>' +
							 					'</div>';
						}
					},
					name : 'diagnosis_case' 
				},
				
				{
					xtype: 'textarea',
					name : 'diagnosis',
					fieldLabel: 'Detail Diagnosa'
				},
		 
			]
    }];

    this.buttons = [{
      text: 'Diagnose',
      action: 'confirmDiagnose'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		this.down('form').getForm().findField('code').setValue(record.get('code')); 
		this.down('form').getForm().findField('item_code').setValue(record.get('item_code')); 
	}
});

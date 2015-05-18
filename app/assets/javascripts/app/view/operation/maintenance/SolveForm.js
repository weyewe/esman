Ext.define('AM.view.operation.maintenance.SolveForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.solvemaintenanceform',

  title : 'Solve',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
		var localJsonStoreSolutionCase = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'solve_case_selector',
			fields	: [ 
				{ name : "solution_case"}, 
				{ name : "solution_case_text"}  
			], 
			data : [
				{ solution_case : 1, solution_case_text : "No Action"},
				{ solution_case : 2, solution_case_text : "Pending"},
				{ solution_case : 3, solution_case_text : "Solved"}
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
	        name : 'solution_date',
	        fieldLabel: ' Waktu solusi',
					dateCfg : {
						format: 'Y-m-d'
					},
					timeCfg : {
						increment : 15
					}
				},
				
				{
					fieldLabel: 'Kasus Solusi',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'solution_case_text',
					valueField : 'solution_case',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreSolutionCase, 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{solution_case_text}">' +  
													'<div class="combo-name">{solution_case_text}</div>' +
							 					'</div>';
						}
					},
					name : 'solution_case' 
				},
				
				{
					xtype: 'textarea',
					name : 'solution',
					fieldLabel: 'Detail Solusi'
				},
		 
			]
    }];

    this.buttons = [{
      text: 'Solve',
      action: 'confirmSolve'
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

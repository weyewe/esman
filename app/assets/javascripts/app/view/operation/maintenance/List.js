Ext.define('AM.view.operation.maintenance.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.maintenancelist',

  	store: 'Maintenances', 
 

	initComponent: function() {
		 
		this.columns = [
			
			{
				xtype : 'templatecolumn',
				text : "Info",
				flex : 1,
				tpl : 'Item: <b>{item_code}</b>' + '<br />' + '<br />' +
							'Staff:<br /> <b>{user_name}</b>'  + '<br />' + '<br />' + 
							'Maintenance Code:<br /> <b>{code}</b>' + '<br />' + '<br />' 
			},
			
			
			{
				xtype : 'templatecolumn',
				text : "Complaint",
				flex : 2,
				tpl : '<b>{complaint_case_text}</b>'  + '<br />' + '<br />' +
				
							'Complaint Date:<br /> <b>{complaint_date}</b>'  + '<br />' + '<br />' + 
							 
							
							'Complaint:<br />{complaint}'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Inspection",
				flex : 2,
				tpl : '<b>{diagnosis_case_text}</b>'  + '<br />' + '<br />' + 
							'Inspection Date:<br /> <b>{diagnosis_date}</b>'  + '<br />' + '<br />' + 
							
							'Diagnosis:<br />{diagnosis}'  + '<br />' + '<br />' 
			},
			
			{
				xtype : 'templatecolumn',
				text : "Solution",
				flex : 2,
				tpl : '<b>{solution_case_text}</b>'  + '<br />' + '<br />' + 
							'Solution Date:<br /> <b>{solution_date}</b>'  + '<br />' + '<br />' + 
							
							'Solution:<br />{diagnosis}'  + '<br />' + '<br />' 
			},
			
			
		 
		];
		
		

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete',
			action: 'deleteObject',
			disabled: true
		});
		
		this.diagnoseObjectButton = new Ext.Button({
			text: 'Diagnose',
			action: 'diagnoseObject',
			disabled: true
		});
		this.undiagnoseObjectButton = new Ext.Button({
			text: 'Undiagnose',
			action: 'undiagnoseObject',
			disabled: true,
			hidden : true 
		});
		
		
		this.solveObjectButton = new Ext.Button({
			text: 'Solve',
			action: 'solveObject',
			disabled: true
		});
		
		this.unsolveObjectButton = new Ext.Button({
			text: 'Unsolve',
			action: 'unsolveObject',
			disabled: true,
			hidden :true 
		});
		
		
		this.confirmObjectButton = new Ext.Button({
			text: 'Confirm',
			action: 'confirmObject',
			disabled: true
		});
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm',
			action: 'unconfirmObject',
			disabled: true,
			hidden :true 
		});
		
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});



		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton, 
			this.diagnoseObjectButton,
			this.undiagnoseObjectButton,
			this.solveObjectButton, 
			this.unsolveObjectButton, 
		
		'->', this.searchField ];
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying topics {0} - {1} of {2}',
			emptyMsg: "No topics to display" 
		});

		this.callParent(arguments);
	},
 
	loadMask	: true,
	
	getSelectedObject: function() {
		return this.getSelectionModel().getSelection()[0];
	},

	enableRecordButtons: function() {
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
		
		this.diagnoseObjectButton.enable();
		this.undiagnoseObjectButton.enable();
		this.solveObjectButton.enable(); 
		this.unsolveObjectButton.enable(); 
		this.confirmObjectButton.enable(); 
		this.unconfirmObjectButton.enable();
		
		
		selectedObject = this.getSelectedObject();
		if( selectedObject && selectedObject.get("is_diagnosed") == true ){
			this.diagnoseObjectButton.hide();
			this.undiagnoseObjectButton.show();
		}else{
			this.diagnoseObjectButton.show();
			this.undiagnoseObjectButton.hide();
		}
		
		if( selectedObject && selectedObject.get("is_solved") == true ){
			this.solveObjectButton.hide();
			this.unsolveObjectButton.show();
		}else{
			this.solveObjectButton.show();
			this.unsolveObjectButton.hide();
		}
		
		
		
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		
		this.diagnoseObjectButton.disable();
		this.undiagnoseObjectButton.disable();
		this.solveObjectButton.disable(); 
		this.unsolveObjectButton.disable(); 
		this.confirmObjectButton.disable(); 
		this.unconfirmObjectButton.disable();
	},
	
	enableAddButton: function(){
		this.addObjectButton.enable();
	},
	disableAddButton : function(){
		this.addObjectButton.disable();
	},
	
	
});

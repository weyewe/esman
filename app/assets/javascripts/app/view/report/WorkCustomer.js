Ext.define('AM.view.report.WorkCustomer', {
    extend: 'AM.view.ChartInspect',
    alias: 'widget.workCustomerReport',

		

 		chartStoreFields : [
			'name',
			'data1',
			'id'
		],
		
		chartStoreUrl :  'api/work_customer_reports', 
		listXType: 'workcustomerList',
		yAxisLabel : "Total maintenance",
		xAxisLabel : "Customer",
		panelTitle : "Customer",
		worksheetId: "#personal-worksheetPanel"
});

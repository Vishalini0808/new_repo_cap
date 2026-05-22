sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"approvalportal/test/integration/pages/PurchaseRequisitionsList",
	"approvalportal/test/integration/pages/PurchaseRequisitionsObjectPage"
], function (JourneyRunner, PurchaseRequisitionsList, PurchaseRequisitionsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('approvalportal') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseRequisitionsList: PurchaseRequisitionsList,
			onThePurchaseRequisitionsObjectPage: PurchaseRequisitionsObjectPage
        },
        async: true
    });

    return runner;
});


sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"requesterportal/test/integration/pages/PurchaseRequisitionsList",
	"requesterportal/test/integration/pages/PurchaseRequisitionsObjectPage",
	"requesterportal/test/integration/pages/PRLineItemsObjectPage"
], function (JourneyRunner, PurchaseRequisitionsList, PurchaseRequisitionsObjectPage, PRLineItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('requesterportal') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseRequisitionsList: PurchaseRequisitionsList,
			onThePurchaseRequisitionsObjectPage: PurchaseRequisitionsObjectPage,
			onThePRLineItemsObjectPage: PRLineItemsObjectPage
        },
        async: true
    });

    return runner;
});


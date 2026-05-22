using { my.hpm as hpm } from  '../db/hpm-schema';

service ReceiptService @(path : '/receipt') {

    entity PurchaseRequisitions as projection on hpm.PurchaseRequisitions;
    entity PRLineItems as projection on hpm.PRLineItems;

    @odata.draft.enabled
    entity GoodsReceipts as projection on hpm.GoodsReceipts;
    entity GRLineItems as projection on hpm.GRLineItems{
    *,
    poLineItem.itemDescription as itemDescription  
    };

    @readonly 
    entity Employees as projection on hpm.Employees ;

    entity PurchaseOrders as projection on hpm.PurchaseOrders actions {
         action confirmReceipt () returns String;
    }

    entity POLineItems as projection on hpm.POLineItems;

   

    function getPendingDeliveries() returns array of PurchaseOrders;
}
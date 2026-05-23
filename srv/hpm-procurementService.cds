using { my.hpm as hpm } from '../db/hpm-schema';

service ProcurementService @(path : '/procurement') {

    entity Vendors as projection on hpm.Vendors;
    entity Employees as projection on hpm.Employees;

    entity Departments as projection on hpm.Departments;
    entity ItemCategories as projection on hpm.ItemCategories;
    

    @odata.draft.enabled
    entity PurchaseRequisitions as projection on hpm.PurchaseRequisitions 
      {
        *,
        virtual pr_criticality : Integer default 0 
    } actions {
            action submitPR ();
            action cancelPR();
            action createPO ( Vendors_ID : UUID, Employees_ID : UUID ) returns UUID;
    };

    entity PRLineItems as projection on hpm.PRLineItems;

    @odata.draft.enabled
    entity PurchaseOrders as projection on hpm.PurchaseOrders 
     {
        *,
        virtual po_criticality : Integer default 0
    } actions {
        action approvePO (  Employees_ID : UUID ) returns String;
        action rejectPO (  reason : String ) returns String;
    }

    entity POLineItems as projection on hpm.POLineItems;
    
}

  

     
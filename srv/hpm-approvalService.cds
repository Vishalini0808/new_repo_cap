using { my.hpm as hpm } from  '../db/hpm-schema';

service ApprovalService @(path : '/approve') {

    @cds.redirection.target
    entity PurchaseRequisitions as projection on hpm.PurchaseRequisitions 
    where pr_status = 'Submitted' or pr_status = 'POCreated' or pr_status = 'Approved'
    actions {
            action approvePR (Employees_ID : UUID ) returns String ;
            action rejectPR( Employees_ID : UUID, reason : String ) returns String;
    }

    // cds view for KPI:
    @readonly
    @Aggregation.ApplySupported : {
    Transformations : [ 'aggregate', 'groupby', 'filter' ]
    }
    entity PRStatuscount as select from hpm.PurchaseRequisitions {
        key pr_status,                          @Analytics.Dimension
        count(*) as totalCount : Integer        @Analytics.Measure 
                                                @Aggregation.default : #SUM
    }
    group by pr_status;


    // @readonly 
    // entity ApprovedPRs as projection on hpm.PurchaseRequisitions 
    // where pr_status = 'Approved';

    entity PRLineItems as projection on hpm.PRLineItems;

    entity Employees as projection on hpm.Employees ;

    entity Vendors as projection on hpm.Vendors;

    @readonly  
    entity PurchaseOrders as projection on hpm.PurchaseOrders
    where po_status = 'PendingApproval'
     actions {
        action approvePO () returns String;
        action rejectPO (  reason : String ) returns String;
    }

    @readonly 
    entity POLineItems as projection on hpm.POLineItems;

}
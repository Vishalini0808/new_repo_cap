namespace my.hpm;

using { cuid } from '@sap/cds/common';


type vendorStatus : String enum { Active ; Inactive };

type vendorCat : String enum {
    Pharma;  MedicalEquipment; 
    LabReagents; GeneralSupply; 
    Services;  IT;
};

type Department : String enum {
    Pharmacy;
    ICU; Laboratory; Radiology;
    GeneralWard; OperationTheatre; EmergencyAndCasualty;
    BiomedicalEngineering; Physiotherapy; Dialysis;
    Housekeeping; Dietary; Laundry; 
    Procurement; Finance; Administration;
}

entity Departments {
    key code : String(30);
    name : String(100);
}

entity ItemCategories {
    key code : String(40);
    name : String(100);
}

type PaymentTerms : String enum {
    Immediate = 'IMM';
    Net15     = 'NET15';
    Net30     = 'NET30';
    Net60     = 'NET60';
    Net90     = 'NET90';
    Advance   = 'ADV';
}

type BasicDetails : {
    name : String(50);
    email : String(255)    @mandatory @assert.format : '^[^@]+@[^@]+\.[^@]+$' ;
    phone : String(20)    @mandatory @assert.format : '^\+?[0-9]{10,15}$' ;
    address : String(200);
};


entity Vendors : cuid {
    code : String ;
    vendorDetails : BasicDetails;
    category : Association to ItemCategories ;
    paymentTerms : PaymentTerms @assert.range;
    rating : Decimal(2,1)         @assert.range : [0,5];
    V_status : vendorStatus       default 'Active' @assert.range;
};


type PRStatus : String enum {
    Draft;
    Submitted;
    Cancelled;
    Approved;
    POCreated;
    POApproved;
    Rejected
}

    entity PurchaseRequisitions : cuid  {
        pr_code : String        @mandatory;
        requester  : Association to Employees;
        department :Association to Departments ;
        estimatedTotalCost : Decimal(15,2);
        pr_status : PRStatus     default 'Draft' @assert.range;
        rejectionReason : String(500);
        submittedAt : Timestamp;
        approvedBy : Association to Employees;
        approvedAt : Timestamp;
        prlineItems : Composition of many PRLineItems on prlineItems.pr = $self;
        po : Association to many PurchaseOrders on po.Pr = $self;
    }


// this pr line item becomes po line item later.
entity PRLineItems : cuid {
    pr : Association to PurchaseRequisitions;
    itemDescription : String(255);
    itemCategory : Association to ItemCategories;
    quantity : Integer                    @assert.range: [1, 9999999];
    estimatedUnitCost : Decimal(15,2)     @assert.range: [0, 9999999];
    estimatedTotalCost : Decimal(15,2);
    requiredByDate : Date;
}

entity Employees : cuid {
    employeeCode : String;
    employeeDetails : BasicDetails;
    department : Department @assert.range;
    designation : String;
    authorizationLimit : Decimal(15,2);
}

type POStatus : String enum {
   PendingApproval;
   PendingEscaltedApproval;
   Approved;
   Rejected;
   PartiallyReceived;
   Received;
}

// created by buyer
entity PurchaseOrders : cuid {
    po_code : String;
    Pr : Association to PurchaseRequisitions;
    vendor : Association to Vendors;
    expectedDeliveryDate : Date;
    totalValue  : Decimal(15,2);
    po_status : POStatus default 'PendingApproval' @assert.range;  //draft- pending
    rejectionReason : String(500);
    
    poLineItems  : Composition of many POLineItems on poLineItems.po = $self;
    gr : Association to many GoodsReceipts on gr.po = $self;
    createdBy : Association to Employees;
    approvedBy : Association to Employees;
}


entity POLineItems : cuid {
    po : Association to PurchaseOrders;
    prlineItem : Association to PRLineItems; 
    itemDescription : String;
    quantity : Integer          @assert.range : [1,999999];
    unitPrice : Decimal(15,2)    @assert.range: [0, 9999999];
    lineTotal : Decimal(15,2);
    deliveredQuantity : Integer;  //gr update data
    // pendingQuantity : Integer;
}


type GRStatus : String enum {
   Confirmed;
   PartiallyReceived;
   Closed;
}

entity GoodsReceipts : cuid {
    gr_code : String;
    po : Association to PurchaseOrders;
    receivedBy : Association to Employees;
    receiptDate : Date;
    gr_status : GRStatus default 'Confirmed' @assert.range;
    grLineItems : Composition of many GRLineItems on grLineItems.gr = $self;
    
}

entity GRLineItems : cuid {
    gr : Association to GoodsReceipts;
    poLineItem : Association to POLineItems;
    receivedQuantity : Integer       @assert.range : [1,999999] ;
    batchNumber : String;
    expiryDate : Date;                                                                                                                                                
}




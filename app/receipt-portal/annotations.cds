using ReceiptService as service from '../../srv/hpm-receiptService';
annotate service.PurchaseOrders with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'po_code',
                Value : po_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'expectedDeliveryDate',
                Value : expectedDeliveryDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'totalValue',
                Value : totalValue,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_status',
                Value : po_status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'rejectionReason',
                Value : rejectionReason,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'POLineItemsFacet',
            Label : 'PO Line Items',
            Target : 'poLineItems/@UI.LineItem',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GoodsReceiptsFacet',
            Label : 'Goods Receipts',
            Target : 'gr/@UI.LineItem',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'PO Code',
            Value : po_code,
        },
         {
            $Type : 'UI.DataField',
            Label : 'Item',
            Value : poLineItems.itemDescription,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Total Value',
            Value : totalValue,
        },
        {
            $Type : 'UI.DataField',
            Label : 'PO Status',
            Value : po_status,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Confirm Receipt',
            Action : 'ReceiptService.confirmReceipt',
            Criticality : #Positive,
            Inline : true,
            ![@UI.Importance] : #High
        }
        
    ],
);

annotate service.PurchaseOrders with actions {
    confirmReceipt @(
        Core.OperationAvailable : {
            $edmJson :{
                $Or :[
                    {
                    $Eq : [
                    { $Path : 'po_status'},
                    'Approved'
                    ]
                    },

                    {
                    $Eq : [
                    { $Path : 'po_status'},
                    'PartiallyReceived'
                    ]
                    },
                    
                ]
            }
        }
    );
};

// side effects
annotate service.PurchaseOrders with actions {
    confirmReceipt @Common.SideEffects : {
        TargetProperties : [ 'po_status']
    }
};


annotate service.PurchaseOrders with @(
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Confirm Receipt',
            Action : 'ReceiptService.confirmReceipt',
            Criticality : #Positive,
            ![@UI.Importance] : #High
        },
    ],
);

annotate service.POLineItems with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Item Description',
            Value : itemDescription,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Ordered Quantity',
            Value : quantity,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Delivered Quantity',
            Value : deliveredQuantity,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Unit Price',
            Value : unitPrice,
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Label : 'Line Total',
            Value : lineTotal,
            ![@UI.Importance] : #Medium
        },
    ],
);

annotate service.GoodsReceipts with @(

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'GR Code',
            Value : gr_code,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Receipt Date',
            Value : receiptDate,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : gr_status,
            ![@UI.Importance] : #High
        },
    ],

    UI.FieldGroup #GRDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'GR Code',
                Value : gr_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Receipt Date',
                Value : receiptDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : gr_status,
            },
        ],
    },

    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GRDetailsFacet',
            Label : 'GR Details',
            Target : '@UI.FieldGroup#GRDetails',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GRLineItemsFacet',
            Label : 'GR Line Items',
            Target : 'grLineItems/@UI.LineItem',
        },
    ],
);

annotate service.GRLineItems with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Item Description',
            Value : itemDescription,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Received Quantity',
            Value : receivedQuantity,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Batch Number',
            Value : batchNumber,
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Label : 'Expiry Date',
            Value : expiryDate,
            ![@UI.Importance] : #Medium
        },
    ],
);

annotate service.PurchaseOrders with {
    Pr @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'PurchaseRequisitions',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : Pr_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'pr_code',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'department_code',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'estimatedTotalCost',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'pr_status',
            },
        ],
    }
};

annotate service.PurchaseOrders with {
    createdBy @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Employees',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : createdBy_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeCode',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_email',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_phone',
            },
        ],
    }
};

annotate service.PurchaseOrders with {
    approvedBy @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Employees',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : approvedBy_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeCode',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_email',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_phone',
            },
        ],
    }
};


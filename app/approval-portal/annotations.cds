using ApprovalService as service from '../../srv/hpm-approvalService';
annotate service.PurchaseRequisitions with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'pr_code',
                Value : pr_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'estimatedTotalCost',
                Value : estimatedTotalCost,
            },
            {
                $Type : 'UI.DataField',
                Label : 'pr_status',
                Value : pr_status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'submittedAt',
                Value : submittedAt,
            },
            {
                $Type : 'UI.DataField',
                Label : 'approvedAt',
                Value : approvedAt,
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
            ID : 'POFacet',
            Label : 'Purchase Orders',
            Target : 'po/@UI.LineItem',   
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'pr_code',
            Value : pr_code,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'estimatedTotalCost',
            Value : estimatedTotalCost,
             @HTML5.CssDefaults:{width:'150px'},   
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Label : 'pr_status',
            Value : pr_status,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'submittedAt',
            Value : submittedAt,
            @HTML5.CssDefaults:{width:'200px'},
            ![@UI.Importance] : #Low

        },
        {
            $Type : 'UI.DataField',
            Label : 'approvedAt',
            Value : approvedAt,
            @HTML5.CssDefaults:{width:'200px'},
            ![@UI.Importance] : #Low
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Approve PR',
            Action : 'ApprovalService.approvePR',
            Inline : true,
            Criticality : #Positive,
            ![@UI.Importance] : #High

        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Reject PR',
            Action : 'ApprovalService.rejectPR',
            Inline : true,
            Criticality : #Negative,
            ![@UI.Importance] : #Medium

        },
    ],
);

annotate service.PurchaseRequisitions with actions {
    approvePR @Common.SideEffects : {
        TargetProperties : [ 'pr_status']
    }
};

annotate service.PurchaseRequisitions with actions {
    rejectPR @Common.SideEffects : {
        TargetProperties : [ 'pr_status']
    }
};

annotate service.PurchaseRequisitions with  actions {
    approvePR @(
        Core.OperationAvailable : {
            $edmJson : {
                $Eq : [
                    { $Path : 'pr_status'},
                    'Submitted'
                ]
            }
        }
    );

     rejectPR @(
        Core.OperationAvailable : {
            $edmJson : {
                $Eq : [
                    { $Path : 'pr_status'},
                    'Submitted'
                ]
            }
        }
    )
};

// PO
annotate service.PurchaseOrders with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'PO Code',
            @HTML5.CssDefaults:{width:'150px'},
            Value : po_code,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Total Value',
            @HTML5.CssDefaults:{width:'150px'},
            Value : totalValue,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : po_status,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Expected Delivery',
            Value : expectedDeliveryDate,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Approve PO',
            Action : 'ApprovalService.approvePO',
             @HTML5.CssDefaults:{width:'150px'},
            Inline : true,
            Criticality : #Positive,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Reject PO',
            Action : 'ApprovalService.rejectPO',
            @HTML5.CssDefaults:{width:'150px'},
            Inline : true,
            Criticality : #Negative,
            ![@UI.Importance] : #Medium
        },
    ],

    // PO Object Page facets
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'POGeneralFacet',
            Label : 'PO Details',
            Target : '@UI.FieldGroup#PODetails',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'VendorFacet',
            Label  : 'Vendor Details',
            Target : 'vendor/@UI.FieldGroup#VendorDetails',
        },
    ],

    UI.FieldGroup #PODetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'PO Code',
                Value : po_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Total Value',
                Value : totalValue,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : po_status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Expected Delivery',
                Value : expectedDeliveryDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Rejection Reason',
                Value : rejectionReason,
            },
        ],
    },
);

annotate service.PRStatuscount with {
    pr_status  @Analytics.Dimension;
    totalCount @Analytics.Measure @Aggregation.default : #SUM;
}


annotate service.PurchaseRequisitions with {
    requester @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Employees',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : requester_ID,
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

annotate service.PurchaseRequisitions with {
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

annotate service.PRStatuscount with @(
    UI.KPI #PendingPRs : {
        $Type : 'UI.KPIType',
        DataPoint : {
            $Type : 'UI.DataPointType',
            Value : totalCount,
            Title : 'Pending Requisitions',
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [{
                $Type        : 'UI.SelectOptionType',
                PropertyName : pr_status,
                Ranges       : [{
                    $Type  : 'UI.SelectionRangeType',
                    Sign   : #Include,
                    Option : #EQ,
                    Low    : 'Submitted'
                }]
            }]
        },
        Detail : {
            $Type : 'UI.KPIDetailType',
            DefaultPresentationVariant : {
                $Type          : 'UI.PresentationVariantType',
                Visualizations : [ '@UI.LineItem' ]
            }
        }
    },

    UI.KPI #ApprovedPRs : {
        $Type : 'UI.KPIType',
        DataPoint : {
            $Type : 'UI.DataPointType',
            Value : totalCount,
            Title : 'Approved Requisitions',
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [{
                $Type        : 'UI.SelectOptionType',
                PropertyName : pr_status,
                Ranges       : [{
                    $Type  : 'UI.SelectionRangeType',
                    Sign   : #Include,
                    Option : #EQ,
                    Low    : 'Approved'
                }]
            }]
        },
        Detail : {
            $Type : 'UI.KPIDetailType',
            DefaultPresentationVariant : {
                $Type          : 'UI.PresentationVariantType',
                Visualizations : [ '@UI.LineItem' ]
            }
        }
    },
);
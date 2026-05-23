using ApprovalService as service from '../../srv/hpm-approvalService';
annotate service.PurchaseRequisitions with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Code',
                Value : pr_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Estimated TotalCost',
                Value : estimatedTotalCost,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Pr Status',
                Value : pr_status,
                Criticality : pr_criticality,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Submitted At',
                Value : submittedAt,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Approved At',
                Value : approvedAt,
            },
        ],
    },

     UI.FieldGroup #prlineitemGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Category',
                Value : prlineItems.itemCategory,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Item',
                Value : prlineItems.itemDescription
            },
            {
                $Type : 'UI.DataField',
                Label : 'Unit Cost',
                Value : prlineItems.estimatedUnitCost
            },
            {
                $Type : 'UI.DataField',
                Label : 'Requested Quantity',
                Value : prlineItems.quantity
            },
            {
                $Type : 'UI.DataField',
                Label : 'Estimated Total Cost',
                Value : prlineItems.estimatedTotalCost,
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
            Label : 'PR Code',
            Value : pr_code,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Item ',
            Value : prlineItems.itemDescription,
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
            Label : 'PR Status',
            Value : pr_status,
            Criticality : pr_criticality,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Submitted At',
            Value : submittedAt,
            @HTML5.CssDefaults:{width:'200px'},
            ![@UI.Importance] : #Low

        },
        {
            $Type : 'UI.DataField',
            Label : 'Approved At',
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

// KPI 
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

// vendor details
annotate service.Vendors with @(

      UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Vendor Code',
            Value : code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Vendor Name',
            Value : vendorDetails_name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Category',
            Value : category_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Rating',
            Value : rating,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : V_status,
        }
    ],

    UI.DataPoint #Rating : {
        Value : rating,
        Title : 'Vendor Rating',
        TargetValue : 5,
        Visualization : #Rating
    },

     UI.HeaderInfo : {
        TypeName : 'Vendor',
        TypeNamePlural : 'Vendors',
        Title : {
            Value : vendorDetails_name
        },
        Description : {
            Value : category_code
        }
    },

    UI.FieldGroup #VendorDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Vendor Code',
                Value : code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Vendor Name',
                Value : vendorDetails_name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Email',
                Value : vendorDetails_email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Vendor Category',
                Value : category_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Payment Terms',
                Value : paymentTerms,
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.DataPoint#Rating',
                Label  : 'Rating',
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : V_status,
            },
        ],
    },

    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'VendorDetailsFacet',
            Label : 'Vendor Details',
            Target : '@UI.FieldGroup#VendorDetails',
        }
    ]
);



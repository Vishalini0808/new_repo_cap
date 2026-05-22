using ProcurementService as service from '../../srv/hpm-procurementService';
annotate service.PurchaseRequisitions with @(

    UI.SelectionFields : [
        department_code,
    ],

    UI.HeaderInfo : {
        TypeName : 'PurchaseRequisition',
        TypeNamePlural : 'PurchaseRequisitions',
        Title : { Value : pr_code},
        Description : { Value : pr_status}
    },

    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'ProcurementService.submitPR',
            Label : 'Submit Request'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'ProcurementService.cancelPR',
            Label : 'Cancel Request'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'ProcurementService.createPO',
            Label : 'Create Purchase Order'
        },
    ],
    
    UI.LineItem  : [
        {
            $Type : 'UI.DataField',
            Label : 'PR Code',
            Value : pr_code,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High

        },
        {
            $Type : 'UI.DataField',
            Label : 'Department',
            Value : department_code,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Estimated TotalCost',
            Value : estimatedTotalCost,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Medium

        },
        {
            $Type : 'UI.DataField',
            Label : 'PR Status',
            Value : pr_status,
            @HTML5.CssDefaults:{width:'100px'},
            ![@UI.Importance] : #High

        },
        {
            $Type : 'UI.DataField',
            Label : 'submittedAt',
            Value : submittedAt,
            ![@UI.Importance] : #Low
        },
         {
            $Type : 'UI.DataFieldForAction',
            Action : 'ProcurementService.submitPR',
            Label : 'Submit PR',
            Inline : true,
            Criticality : #Positive,
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'ProcurementService.cancelPR',
            Label : 'Cancel PR',
            Inline : true,
            Criticality : #Negative,
            ![@UI.Importance] : #Medium

        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'ProcurementService.createPO',
            Label : 'Create PurchaseOrder',
            Inline : true,
            ![@UI.Importance] : #Medium,
            ![@UI.Hidden] : {
                $edmJson : {
                    $Ne : [
                        { $Path : 'pr_status'},
                        'Approved'
                    ]
                }
            }
        },
    ],

    //general facet
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'PR CODE',
                Value : pr_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Department',
                Value : department_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Estimated TotalCost',
                Value : estimatedTotalCost,
            },
            {
                $Type : 'UI.DataField',
                Label : 'PR Status',
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

    // employee facet
    UI.FieldGroup #RequeterDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Employee ID',
                Value : requester_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Employee Code',
                Value : requester.employeeCode,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Employee Name',
                Value : requester.employeeDetails_name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'EmailID',
                Value : requester.employeeDetails_email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Department',
                Value : requester.department,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Designation',
                Value : requester.designation,
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
            ID : 'EmployeeDetailsFacet',
            Label : 'Employee Details',
            Target : '@UI.FieldGroup#RequeterDetails'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'LineItemsFacet',
            Label : ' PR LineItems',
            Target : 'prlineItems/@UI.LineItem'
        }, 
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'POListPageFacet',
            Label : 'Purchase Orders',
            Target : 'po/@UI.LineItem'
        },
    ],
);


// PR LineItems
annotate service.PRLineItems with @(
    UI: {
        LineItem  : [
             {
            $Type : 'UI.DataField',
            Label : 'Item Description',
            Value : itemDescription,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Item Category',
            Value : itemCategory_code,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
         {
            $Type : 'UI.DataField',
            Label : 'Quantity',
            Value : quantity,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Estimated Unit Cost',
            Value : estimatedUnitCost,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Medium
        },
         {
            $Type : 'UI.DataField',
            Label : 'Required By Date',
            Value : requiredByDate,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Medium
        }
        ],

        //  PR Lineitem general facet
        FieldGroup #GeneralInfo : {
            $Type : 'UI.FieldGroupType',
            Data : [
                {
                $Type : 'UI.DataField',
                Label : 'Item Description',
                Value : itemDescription,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Item Category',
                Value : itemCategory_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Quantity',
                Value : quantity,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Estimated Unit Cost',
                Value : estimatedUnitCost,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Required By Date',
                Value : requiredByDate,
            },
            ]
        },

        Facets  : [
            {
                $Type : 'UI.ReferenceFacet',
                ID : 'GeneralField',
                Label : 'Genaral Info',
                Target : '@UI.FieldGroup#GeneralInfo',
            }
        ],
    }
) ;


// Button Availability
annotate service.PurchaseRequisitions with actions {
    submitPR @(
        Core.OperationAvailable : {
            $edmJson :{
                $Eq : [
                    { $Path : 'pr_status'},
                    'Draft'
                ]
            }
        }
    );

    cancelPR @(
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

// side effects
annotate service.PurchaseRequisitions with actions {
    submitPR @Common.SideEffects : {
        TargetProperties : [ 'pr_status']
    }
};

annotate service.PurchaseRequisitions with actions {
    cancelPR @Common.SideEffects : {
        TargetProperties : [ 'pr_status']
    }
};

annotate service.PurchaseRequisitions with actions {
    createPO @Common.SideEffects : {
        TargetProperties : [ 'pr_status']
    }
};


// dropdown- department
annotate service.PurchaseRequisitions with {

    department @(
        Common.ValueList: {
            CollectionPath: 'Departments',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: department_code,
                    ValueListProperty: 'code'
                }
            ]
        },
        Common.ValueListWithFixedValues : true
    );

};

// dropdown- item category
annotate service.PRLineItems with {

    itemCategory @(
        Common.ValueList: {
            CollectionPath: 'ItemCategories',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: itemCategory_code,
                    ValueListProperty: 'code'
                }
            ]
        },
        Common.ValueListWithFixedValues : true
    );

};

annotate service.PurchaseRequisitions with actions {
     createPO (
        Vendors_ID @(
            Common.Label : 'Vendor',
            Common.ValueList : {
                $Type : 'Common.ValueListType',
                CollectionPath : 'Vendors',
                Parameters : [
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        LocalDataProperty : Vendors_ID,
                        ValueListProperty : 'ID',
                    },
                    {
                        $Type : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty : 'code',
                    },
                    {
                        $Type : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty : 'vendorDetails_name',
                    },
                    {
                        $Type : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty : 'category_code',
                    }
                ]
            },
            Common.ValueListWithFixedValues : false
        ),

        
        Employees_ID @(
            Common.Label : 'Employee',
            Common.ValueList : {
                $Type : 'Common.ValueListType',
                CollectionPath : 'Employees',
                Parameters : [
                     {
                        $Type : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty : 'employeeCode',
                    },
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        ValueListProperty : 'designation',
                    },
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        ValueListProperty : 'department',
                    },
                    {
                        $Type : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty : 'employeeDetails_name',
                    },
                ]
            },
            Common.ValueListWithFixedValues : false
            )
     );
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
                ValueListProperty : 'designation',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'department',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeDetails_email',
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


// PO List and Object page:
annotate service.PurchaseOrders with @(

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'PO Code',
            Value : po_code,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'PO Status',
            Value : po_status,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Label : 'Total',
            Value : totalValue,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Label : 'Delivery Date',
            Value : expectedDeliveryDate,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Label : 'PR ID',
            Value : Pr_ID,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Medium
        },
        {
            $Type : 'UI.DataField',
            Label : 'Vendor ID',
            Value : vendor_ID,
            @HTML5.CssDefaults:{width:'150px'},
            ![@UI.Importance] : #Low
        },
    ],

     UI.HeaderInfo : {
        TypeName : 'Purchase Order',
        TypeNamePlural : 'Purchase Orders',
        Title : { Value : po_code},
        Description : { Value : po_status}
    },

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
            Label : 'PO Status',
            Value : po_status,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Total',
            Value : totalValue,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Delivery Date',
            Value : expectedDeliveryDate,
        },
        {
            $Type : 'UI.DataField',
            Label : 'PR ID',
            Value : Pr_ID,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Vendor ID',
            Value : vendor_ID,
        }
        ]
    },

    UI.Facets : [
         {
            $Type : 'UI.ReferenceFacet',
            ID : 'PODetails',
            Label : ' Purchase Orders Details',
            Target : '@UI.FieldGroup#PODetails',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'VendorFacet',
            Label  : 'Vendor Details',
            Target : 'vendor/@UI.FieldGroup#VendorDetails',
        },
    ]

);

// vendor details
annotate service.Vendors with @(

    UI.DataPoint #Rating : {
        Value : rating,
        Title : 'Vendor Rating',
        TargetValue : 5,
        Visualization : #Rating
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

    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'VendorDetailsFacet',
            Label : 'Vendor Details',
            Target : '@UI.FieldGroup#VendorDetails',
        }
    ]
);



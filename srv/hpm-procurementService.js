const cds = require ('@sap/cds');
const { SELECT, INSERT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');


const CRITICALITY = {
    PR : {
        Draft   : 0,   
        Submitted  : 5,  
        Cancelled  : 1,   
        Approved  : 3,  
        POCreated  : 3,   
        POApproved : 3,   
        Rejected  : 1    
    },

    PO : {
        PendingApproval   : 2,
        PendingEscaltedApproval : 2,
        Approved   : 3,
        Rejected   : 1,
        PartiallyReceived   : 2,
        Received    : 3
    }
}

module.exports = cds.service.impl ( async function () {

    const { Vendors, Employees, PurchaseRequisitions, PRLineItems, PurchaseOrders,POLineItems } = this.entities;


   //create PR : before 
   this.before('NEW', 'ProcurementService.PurchaseRequisitions.drafts', async (req) => {

    console.log("NEW handler triggered");

    const year = new Date().getFullYear();
    const num = Date.now().toString().slice(-6);

    req.data.pr_code = `PR-${year}-${num}`;

     });    
    

    //  ------------------------------------------------------------------------------------------------------------------------

    this.before(['CREATE', 'UPDATE'], PurchaseRequisitions, async (req) => {

        
        req.data.pr_status = 'Draft';

        const items = req.data.prlineItems || [];

        let total = 0;
        
        for (const item of items) {

        const itemTotal = Number(item.quantity || 0) * Number(item.estimatedUnitCost || 0);

        item.estimatedTotalCost = itemTotal;          //singlelinetotal

        total += itemTotal;                           //prline total
       };
       
       req.data.estimatedTotalCost = total;

    });


    // -------------------------------------------------------------------

    this.before(['CREATE', 'UPDATE'], PRLineItems, async (req) => {

        const qty = Number(req.data.quantity || 0);
        const unitCost = Number(req.data.estimatedUnitCost || 0);

        req.data.estimatedTotalCost = qty * unitCost;

    });

   
 // Update header total -------------------------------------------------------------------

   
    this.after(['CREATE', 'UPDATE', 'DELETE'], PRLineItems, async (data, req) => {

    const prID = data.pr_ID || req.data.pr_ID;

    if (!prID) return;

    const items = await SELECT.from(PRLineItems)
        .where({ pr_ID: prID });

    let total = 0;

    for (const item of items) {
        total += Number(item.estimatedTotalCost || 0);
    }

    // update PR
    await UPDATE(PurchaseRequisitions).set({ estimatedTotalCost: total }).where({ ID: prID });

});

// -------------------------------------------------------------------------------------------------------------------------------

// criticality mapping:

this.after('READ',PurchaseRequisitions, async(results, req) => {
    (Array.isArray(results) ? results : [results]).forEach(pr => {
        pr.pr_criticality = CRITICALITY.PR[pr.pr_status] ?? 0
    });
})

this.after('READ',PurchaseOrders, async(results, req) => {
    (Array.isArray(results) ? results : [results]).forEach(po => {
        po.po_criticality = CRITICALITY.PO[po.po_status] ?? 0
    });
})
   
// -------------------------------------------------------------------------------------------------------------------------------

   this.before('CREATE',Employees, async(req)=>{

    const { department, designation } = req.data;
    if(!department || !designation ){
        return req.error(400,"Department and Designation Must be given")
    }

    // code:
    const year =  new Date().getFullYear();
    const num = Date.now().toString().slice(-6);
    const code = `EMP-${year}-${num}`;

    req.data.employeeCode = code;

   });

//  -----------------------------------------------------------------------------------------


   this.before('CREATE',Vendors, async(req)=>{

    const { category_code , rating } = req.data;
    if(!category_code || !rating ){
        return req.error(400,"category and rating Must be given")
    }

    // code:
    const year =  new Date().getFullYear();
    const num = Date.now().toString().slice(-6);
    const code = `EMP-${year}-${num}`;

    req.data.code = code;

   });

// ---------------------------------------------------------------------------------------------------------------------------

    //  Submit PR
    this.on('submitPR', async(req) => {

        const { ID } = req.params[0];

    const pr = await SELECT.one.from(PurchaseRequisitions).where({ ID })

    if (!pr) {
        return req.reject(400, 'PR not found');
    }
    if (pr.pr_status !== 'Draft') {
        return req.reject(400, 'Only Draft PR can be submitted');
    }
    
    const lineItems = await  SELECT.from(PRLineItems).where({ pr_ID : ID })

    if (lineItems.length === 0) {
        return req.reject(400, 'Cannot submit PR without line items');
    }

    await UPDATE(PurchaseRequisitions).set({
                pr_status: 'Submitted',
                submittedAt: new Date()
            })
            .where({ ID });

    req.info(200, 'PR submitted successfully');
    });

    //  ------------------------------------------------------------------------------------------------------------

    // Cancel PR
    this.on('cancelPR', async (req) => {

         const { ID } = req.params[0];

    const pr = await SELECT.one.from(PurchaseRequisitions).where({ ID });
    if (!pr) {
        return req.reject(404, 'PR not found');
    }

    if (pr.pr_status === 'Approved') {
        return req.reject(400, 'Approved PR cannot be cancelled');
    }

    if (pr.pr_status === 'Cancelled') {
        return req.reject(400, 'PR is already cancelled');
    }

    await UPDATE(PurchaseRequisitions).set({
            pr_status: 'Cancelled',
            cancelledAt: new Date()
        }).where({ ID });

    req.info(200, 'PR cancelled successfully');

     });

// ------------------------------------------------------------------------------------------------------------------------

       // createPO
    this.on('createPO', PurchaseRequisitions, async(req)=> {

        const { ID } = req.params[0];

        const {  Vendors_ID, Employees_ID } = req.data ;

        const pr = await SELECT.one.from(PurchaseRequisitions).where({ ID });
        if(!pr){
            return req.error(400,"Purchase Requisition Not found")
        }
        if(pr.pr_status !=='Approved') {
            return req.error(400,"only Approved PR can create PO")
        }

        const vendor = await SELECT.one.from(Vendors).where({ ID : Vendors_ID});
        if(!vendor){
            return req.error(400,"Vendor Not found")
        }

        const employee = await SELECT.one.from(Employees).where({ ID : Employees_ID});
        if(!employee){
            return req.error(400,"Employee Not found")
        }

        const prLine = await SELECT.from(PRLineItems).where({ pr_ID : ID});
        console.log(prLine);
        
        if(prLine.length === 0){
            return  req.error(400,"No PR LineItems found")
        }

        // code
        const year = new Date().getFullYear()
        const num = Date.now().toString().slice(-6);
        const code = `PO-${year}-${num}`

        // using reduce:
        const total = prLine.reduce((sum,item) => sum + Number(item.estimatedTotalCost),0);

        const poID = cds.utils.uuid();

        // create PO
        await INSERT.into(PurchaseOrders).entries({
            ID : poID,
            po_code: code,
            Pr_ID: ID,
            vendor_ID: Vendors_ID,
            expectedDeliveryDate : prLine.requiredByDate,
            createdBy_ID: Employees_ID,
            totalValue: total,
            po_status: 'PendingApproval'
        });

        // copy from PR lineitem
        const poLineItems = prLine.map(item => ({
            po_ID : poID,
            prlineItem_ID : item.ID,
            itemDescription : item.itemDescription ,
            quantity : item.quantity ,
            unitPrice : item.estimatedUnitCost ,
            lineTotal : item.estimatedTotalCost,
            deliveredQuantity : 0
        }));

        await INSERT.into(POLineItems).entries(poLineItems);

        // update PR sts
        await UPDATE(PurchaseRequisitions).set({ pr_status : 'POCreated'}).where({ ID });

        req.notify("PO Created Successfully");

        return `PO created Successfully for PO ID : ${poID}`
    });

// ------------------------------------------------------------------------------------------------------------------------

   

});
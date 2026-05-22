const cds = require ('@sap/cds');

module.exports =  cds.service.impl(async function() {

    const { PurchaseRequisitions, Employees } = this.entities;
    
    // approve PR
    this.on('approvePR', PurchaseRequisitions, async(req) => {
        const ID  = req.params[0].ID;
        const { Employees_ID} = req.data;

        const Pr = await SELECT.one.from(PurchaseRequisitions).where({ ID });
        if(!Pr) {
            return req.error(400, "PR not found")
        }

        if(Pr.pr_status !== 'Submitted') {
            return req.error(400,"Only Submitted PR can be Approved")
        }

        const Emp = await SELECT.one.from(Employees).where({ ID : Employees_ID});
        if(!Emp) {
            return req.error(400,"Employee Not Found")
        }

        await UPDATE(PurchaseRequisitions).set({
            pr_status : 'Approved',
            approvedBy_ID : Employees_ID,
            approvedAt : new Date()
        }).where({ ID })

        return "PR approved succuessfully!!"
    });

//---------------------------------------------------------------------------------------------------------------

this.on('rejectPR', PurchaseRequisitions, async (req) => {

    const { ID } = req.params[0];

    const { Employees_ID, reason } = req.data;

    const pr = await SELECT.one
        .from(PurchaseRequisitions)
        .where({ ID });

    if (!pr) {
        return req.error(400, 'PR not found');
    }

    if (pr.pr_status !== 'Submitted') {
        return req.error(400, 'Only Submitted PR can be Rejected');
    }

    const emp = await SELECT.one
        .from(Employees)
        .where({ ID: Employees_ID });

    if (!emp) {
        return req.error(400, 'Employee Not Found');
    }

    await UPDATE(PurchaseRequisitions)
        .set({
            pr_status: 'Rejected',
            approvedBy_ID: Employees_ID,
            approvedAt: new Date(),
            // rejectionReason : reason
        })
        .where({ ID });

    req.info('PR rejected successfully');

    return 'PR rejected successfully';

});


// -----------------------------------------------------------------------------------------------



 this.on('approvePO',async(req)=> {

    const  {PurchaseOrders} = cds.entities('my.hpm')

        const PurchaseOrders_ID = req.params[1].ID
        console.log(req.params)
        
        console.log('PO ID extracted:', PurchaseOrders_ID)

        const {  Employees_ID } = req.data;

        const po = await SELECT.one.from(PurchaseOrders).where({ ID : PurchaseOrders_ID });
        if(!po) {
            return req.error(400,"Purchase Order not found")
        }

        const emp = await SELECT.one.from(Employees).where({ ID : Employees_ID });
        if(!emp){
            return req.error(400,"Employee not found")
        }

        if(Number(emp.authorizationLimit) >= Number(po.totalValue)){
            await UPDATE(PurchaseOrders).set({
                po_status : 'Approved',
                approvedBy_ID : Employees_ID
            }).where({ ID : PurchaseOrders_ID });

            req.notify("Purchase Order Approved")
            return `PO Approved`
        }

        // if authlimit not enough -> next employee auth limit chech
        const nextApprover = await SELECT.one.from(Employees).where({
            authorizationLimit : { '>=' : Number(po.totalValue) }
        }).orderBy({ authorizationLimit : 'asc'});

        if(!nextApprover){
            return req.error(400,"Cannot find next Approver with Auth Limit")
        }
        
        // forwarded
        await UPDATE(PurchaseOrders).set({
            po_status  : 'PendingEscaltedApproval', approvedBy_ID : nextApprover.ID
        }).where ({ ID : PurchaseOrders_ID});

        return `Forwarded PO to ${ nextApprover.name}- ${nextApprover.designation}`
    });

// ----------------------------------------------------------------------------------------------------------

    this.on('rejectPO', async (req) => {

        const { PurchaseOrders} = cds.entities('my.hpm')

        const PurchaseOrders_ID = req.params[1].ID;
        const { reason } = req.data;

    const po = await SELECT.one.from(PurchaseOrders).where({ ID: PurchaseOrders_ID });
    if (!po) return req.error(400, "Purchase Order not found");

    if (po.po_status === 'Approved' || po.po_status === 'Rejected') {
        return req.error(400, `PO is already ${po.po_status}`);
    }

    await UPDATE(PurchaseOrders).set({
        po_status: 'Rejected',
        rejectionReason  : reason
    }).where({ ID: PurchaseOrders_ID });

    return `PO Rejected — Reason: ${reason}`;
    });


})

 
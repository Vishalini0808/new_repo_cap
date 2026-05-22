const cds = require('@sap/cds');
const { SELECT, INSERT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');

module.exports = cds.service.impl(async function () {

    const { GoodsReceipts, GRLineItems, PurchaseOrders, POLineItems, Employees} = this.entities;

    this.on('confirmReceipt',PurchaseOrders, async(req) => {

        const  PurchaseOrders_ID  = req.params[0].ID;
        
        const po = await SELECT.one.from(PurchaseOrders).where({ ID : PurchaseOrders_ID});
        if(!po){
            return req.error(400,"Purchase Order Not Found")
        }

        if(po.po_status !== 'Approved' && po.po_status !== 'PartiallyReceived') {
            return req.error(400, "PO is not Ready for receipt")
        }

        const poLineItems = await SELECT.from(POLineItems).where({ po_ID : PurchaseOrders_ID }) 

         // treat ordered quantity as received quantity (full receipt)
        const receivedItems = poLineItems.map(line => ({
        poLineItem_ID    : line.ID,
        receivedQuantity : line.quantity,  
        batchNumber      : null,           
        expiryDate       : null
        }))


        // create GR
        const year = new Date().getFullYear();
        const num = Date.now().toString().slice(-6);
        const code = `GR-${year}-${num}`;

        const GoodsReceipts_ID = cds.utils.uuid();

        await INSERT.into(GoodsReceipts).entries({
            ID : GoodsReceipts_ID,
            gr_code : code,
            po_ID : PurchaseOrders_ID,
            receiptDate : new Date(),
            gr_status : 'Confirmed'
        });

        // GR lineItems:
        for(const item of receivedItems) {
            await INSERT.into(GRLineItems).entries({
                ID : cds.utils.uuid(),
                gr_ID : GoodsReceipts_ID,
                poLineItem_ID : item.poLineItem_ID,
                receivedQuantity : item.receivedQuantity,
                batchNumber : item.batchNumber,
                expiryDate : item.expiryDate
            });

        // update delivery quantity in polineitems
        const polineitem = await SELECT.one.from(POLineItems).where({ ID : item.poLineItem_ID});
        
        await UPDATE(POLineItems).set({ 
            deliveredQuantity : (polineitem.deliveredQuantity || 0 )+ item.receivedQuantity
        }).where ({ ID : item.poLineItem_ID });

        }

        return `Updated Goods Receipt!`
    });

    // ---------------------------------------------------------

    this.after('confirmReceipt', async (result, req) => {
    const { PurchaseOrders, POLineItems } = cds.entities('my.hpm')

    const PurchaseOrders_ID = req.params[0].ID

    const allLines = await SELECT.from(POLineItems).where({ po_ID : PurchaseOrders_ID }) 

    const fullyReceived = allLines.every(
        line => line.deliveredQuantity >= line.quantity
    )

    await UPDATE(PurchaseOrders).set({ 
        po_status : fullyReceived ? 'Received' : 'PartiallyReceived' 
    }).where({ ID : PurchaseOrders_ID });

    req.info(fullyReceived ? 'PO Fully Received' : 'Partially Received');

    });


});
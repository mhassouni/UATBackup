public class PF_InvoiceCreditAction {

    @InvocableMethod(label='Credit' description='Credit the Invoice.')
    public static void invoiceCredit(List<Id> InvoiceIds)
    {
        for(Id invId: InvoiceIds)
        {
        	blng.InvoiceAPI.creditInvoice(invId, 'Credit');
        }
    }
}
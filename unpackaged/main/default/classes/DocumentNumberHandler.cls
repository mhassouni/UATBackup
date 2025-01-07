public class DocumentNumberHandler {
    
    @TestVisible 
    private static String FormatPostedNumber(Datetime createdDate, String company, String type, Integer sequence) {
        
        //prepare the posted number
        Integer year = createdDate.year();
        String strYearDigits=String.valueOf(year).right(2); //from 2021 take 21
        Integer month = createdDate.month();
        String strMonth = String.valueOf(month).leftPad(2, '0'); //take month, eventually add leading 0
        //company in Phase1 is always 'CO'(for COntainers)
        //type is 'L' for invoice or 'A' for credit note
        String strAgency='001'; //always 001
        String strSequence = String.valueOf(sequence).leftPad(5, '0');
        
        String formated_posted_number=strYearDigits + strMonth + company + strAgency+ type + strSequence;
        
        return(formated_posted_number);
    }
    
    public static void CreateInvoiceNumber(List<blng__Invoice__c> invs, Map<Id,blng__Invoice__c> oldinvs) {
        
        
        //get the sequence number
        List<Document_Number__c> document_number_settings = [select Id,Name, Company__c,Year__c, Sequence__c from Document_Number__c];
        
        Map<String, Document_Number__c> documentsMap = new Map<String, Document_Number__c> {};
            
            for(Document_Number__c dn : document_number_settings) {
                documentsMap.put(dn.Name+dn.Company__c+dn.Year__c, dn);
            }
        
        Integer Sequence;
        
        for(blng__Invoice__c inv : invs) {
            
            
            //if Invoice is Internal - do nothing. Generate sequence only for the External documents.
        	if(inv.PF_Internal__c == true) return;
            
            blng__Invoice__c oldInv = oldinvs.get(inv.Id);
            
            Boolean oldInvStatus = oldInv.blng__InvoiceStatus__c.equals('Posted');
            Boolean newInvStatus = inv.blng__InvoiceStatus__c.equals('Posted');
            
            // Check that the Status field was changed to the correct value (from anything to Posted)
            if (!oldInvStatus && newInvStatus) {
                if(!documentsMap.isEmpty() && documentsMap.containsKey('InvoiceCO'+inv.CreatedDate.year())){
                    Sequence=documentsMap.get('InvoiceCO'+inv.CreatedDate.year()).Sequence__c.intValue(); //get the current sequence from the map
                    inv.Posted_Invoice_Number__c=FormatPostedNumber(inv.CreatedDate,'CO','L',Sequence); 
                    documentsMap.get('InvoiceCO'+inv.CreatedDate.year()).Sequence__c++; //increase the sequence
                }
                
            }
        } 
        
        //store the last sequence numbers (several sequence values can be updated in the loop, if documents from different years are posted)
        update document_number_settings;
        
    }
    
    
    public static void CreateCreditNoteNumber(List<blng__CreditNote__c> cns, Map<Id,blng__CreditNote__c> oldCns) {
        //get the sequence number
        List<Document_Number__c> document_number_settings = [select Id,Name, Company__c,Year__c, Sequence__c from Document_Number__c];
        
        Map<String, Document_Number__c> documentsMap = new Map<String, Document_Number__c> {};
            
            for(Document_Number__c dn : document_number_settings) {
                documentsMap.put(dn.Name+dn.Company__c+dn.Year__c, dn);
            }
        
        Integer Sequence;
        
        for(blng__CreditNote__c cn : cns) {
            
            //if CreditNote is Internal - do nothing. Generate sequence only for the External documents.
        	if(cn.PF_Internal__c == true) return;
            
            blng__CreditNote__c oldCn = oldCns.get(cn.Id);
            
            Boolean oldCnStatus = oldCn.blng__Status__c.equals('Posted');
            Boolean newCnStatus = cn.blng__Status__c.equals('Posted');
            
            // Check that the Status field was changed to the correct value (from anything to Posted)
            if (!oldCnStatus && newCnStatus) {
                if(!documentsMap.isEmpty() && documentsMap.containsKey('CreditNoteCO'+cn.CreatedDate.year())){
                    Sequence=documentsMap.get('CreditNoteCO'+cn.CreatedDate.year()).Sequence__c.intValue(); //get the current sequence from the map
                    cn.Posted_CreditNote_Number__c=FormatPostedNumber(cn.CreatedDate,'CO','A',Sequence);
                    documentsMap.get('CreditNoteCO'+cn.CreatedDate.year()).Sequence__c++; //increase the sequence
                }
            }
        }
        
        //store the last sequence numbers (several sequence values can be updated in the loop, if documents from different years are posted)
        update document_number_settings;
        
    }
    
    //Used to number sequentially the Invoice lines
    public static void updateNumberInvoiceLine(List<blng__Invoice__c> invs, Map<Id,blng__Invoice__c> oldinvs) {
        
        Set<Id> postedInvoices = new Set<Id>();
        
        //Get list of posted invoices 
        for(blng__Invoice__c inv: invs){
            if(inv.blng__InvoiceStatus__c != oldinvs.get(inv.Id).blng__InvoiceStatus__c &&  inv.blng__InvoiceStatus__c  == 'Posted'){
                postedInvoices.add(inv.Id);
            }
        }
        
        if(!postedInvoices.isEmpty()){
            Map<Id, List<blng__InvoiceLine__c>> mapOfInvoiceLines = new  Map<Id, list<blng__InvoiceLine__c>>();
            
            for(blng__InvoiceLine__c  inv: [SELECT blng__Invoice__c, Line_Number__c  FROM blng__InvoiceLine__c WHERE blng__Invoice__c IN :postedInvoices  ORDER BY CreatedDate ASC]){
                if(mapOfInvoiceLines.containsKey(inv.blng__Invoice__c)){
                    mapOfInvoiceLines.get(inv.blng__Invoice__c).add(inv);
                }
                else{
                    mapOfInvoiceLines.put(inv.blng__Invoice__c, new list<blng__InvoiceLine__c>{inv} );
                }
            }
            
            if(!mapOfInvoiceLines.isEmpty() ){
                List<blng__InvoiceLine__c> invoicelinesToUpdate = setInvoiceNumberlines(mapOfInvoiceLines);// call numberLines TO Number each line of the invoice
                if(invoicelinesToUpdate != null && !invoicelinesToUpdate.isEmpty()){
                    update invoicelinesToUpdate;//update invoicelines with new Line_Number__c
                }
            }
        }
        
    }
    
    
    @TestVisible
    private static list<blng__InvoiceLine__c> setInvoiceNumberlines( Map<Id, List<blng__InvoiceLine__c>> invoiceLines) {
        
        List<blng__InvoiceLine__c> updatedLines = new List<blng__InvoiceLine__c>();
        
        for(Id InvoiceId : invoiceLines.keySet()){
            if(invoiceLines.get(InvoiceId) != null && !invoiceLines.get(InvoiceId).isEmpty()){
                for(Integer i = 0; i<invoiceLines.get(InvoiceId).size(); i++){
                    invoiceLines.get(InvoiceId)[i].Line_Number__c = i+1 ;// Number sequentially the Invoice lines
                    updatedLines.add(invoiceLines.get(InvoiceId)[i]);
                }
            }
            
        }
        return updatedLines;
        
        
    }
    
    //Used to number sequentially the Credit Note lines
    public static void updateNumberCreditNotesLine(List<blng__CreditNote__c> cns, Map<Id,blng__CreditNote__c> oldCns) {        
        Set<Id> postedcreditNotes = new Set<Id>();
        
        //Get list of posted invoices 
        for(blng__CreditNote__c  cn: cns){
            if(cn.blng__Status__c != oldCns.get(cn.Id).blng__Status__c &&  cn.blng__Status__c  == 'Posted'){
                postedcreditNotes.add(cn.Id);
            }
        }
        
        Map<String, List<blng__CreditNoteLine__c>> mapOfCreditNotes = new  Map<String, list<blng__CreditNoteLine__c>>();
        
        for(blng__CreditNoteLine__c  cn: [SELECT blng__CreditNote__c, Line_Number__c  FROM blng__CreditNoteLine__c WHERE blng__CreditNote__c IN :postedcreditNotes  ORDER BY CreatedDate ASC]){
            if(mapOfCreditNotes.containsKey(cn.blng__CreditNote__c)){
                mapOfCreditNotes.get(cn.blng__CreditNote__c).add(cn);
            }
            else{
                mapOfCreditNotes.put(cn.blng__CreditNote__c, new list<blng__CreditNoteLine__c>{cn} );
            }
        }
        
        if(mapOfCreditNotes != null && !mapOfCreditNotes.isEmpty() ){
            List<blng__CreditNoteLine__c> creditNoteslinesToUpdate = setCreditNoteNumberlines(mapOfCreditNotes);// call numberLines TO Number each line of the Credit note
            if(creditNoteslinesToUpdate != null && !creditNoteslinesToUpdate.isEmpty()){
                update creditNoteslinesToUpdate;//update Credit notes lines with new Line_Number__c
            }
        }
    }
    
    
    @TestVisible
    private static list<blng__CreditNoteLine__c> setCreditNoteNumberlines( Map<String, List<blng__CreditNoteLine__c>> creditNotesLines) {
        List<blng__CreditNoteLine__c> updatedLines = new List<blng__CreditNoteLine__c>();
        for(String CreditNoteId : creditNotesLines.keySet()){
            if(creditNotesLines.get(CreditNoteId) != null && !creditNotesLines.get(CreditNoteId).isEmpty()){
                for(Integer i = 0; i<creditNotesLines.get(CreditNoteId).size(); i++){
                    creditNotesLines.get(CreditNoteId)[i].Line_Number__c = i+1 ;//number sequentially the Credit note  lines
                    updatedLines.add(creditNotesLines.get(CreditNoteId)[i]);
                }
            }
            
        }
        return updatedLines;
    }
    
}
trigger ContentDocumentLink_Trigger on ContentDocumentLink (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        system.debug('inside trigger of contentDoc');
        Set<ID> contentDocIds = new Set<ID>();
        for(ContentDocumentLink cdl: Trigger.new){
            contentDocIds.add(cdl.ContentDocumentId);
        }
        
        Set<Id> contractIds = new Set<Id>();
        Map<String,String> contractMap = new Map<String,String>();
        Set<Id> invoicesIds = new Set<Id>();
        Set<Id> creditNotesIds = new Set<Id>();
        List<ContentDocumentLink> QuotesList = new List<ContentDocumentLink>();
		List<ContentDocumentLink> ISList = new List<ContentDocumentLink>();
        Set<Id> OrdersIds = new Set<Id>();
        
        
        for(ContentDocumentLink cdlObj: Trigger.new)
        {
            if(String.valueOf(cdlObj.LinkedEntityId).startsWith('800')){ //Check if file is uploaded on contract object
                contractIds.add(cdlObj.LinkedEntityId);
            }
            if((cdlObj.LinkedEntityId).getSObjectType().getDescribe().getName()=='blng__Invoice__c'){ //Check if file is uploaded on invoice object
                system.debug('this is an invoice');
                invoicesIds.add(cdlObj.LinkedEntityId);
            }
            if((cdlObj.LinkedEntityId).getSObjectType().getDescribe().getName()=='blng__CreditNote__c'){ //Check if file is uploaded on creditNote object
                system.debug('this is a creditNote');
                creditNotesIds.add(cdlObj.LinkedEntityId);
            }
           if((cdlObj.LinkedEntityId).getSObjectType().getDescribe().getName()=='SBQQ__Quote__c'){ //Check if file is uploaded on SBQQ__Quote__c object
                QuotesList.add(cdlObj);
            }
            if((cdlObj.LinkedEntityId).getSObjectType().getDescribe().getName()=='Information_Sheet__c'){ //Check if file is uploaded on Fiche renseignement object
                ISList.add(cdlObj);
            }
           if((cdlObj.LinkedEntityId).getSObjectType().getDescribe().getName()=='Order'){ //Check if file is uploaded on Order object
                ContentDocument C = [select title,fileextension from ContentDocument where id=:cdlObj.ContentDocumentId];
               if((C.Title.startsWithIgnoreCase('Acompte') || C.Title.startsWithIgnoreCase('Dépôt de Garantie')) && C.FileExtension=='PDF' )
               {
                   OrdersIds.add(cdlObj.LinkedEntityId);
               }
            }
        }
        //traitement Fiche de renseignement
        if(ISList.size()>0){CopyFiles_Quote.CopyFileFromQuote(ISList);}

        //Traitement des Quotes
        if(QuotesList.size()>0){CopyFiles_Quote.CopyFileFromQuote(QuotesList);}
        
        //traitement des contracts
        for(contract e:[select id,SBQQ__Quote__c  from contract where Id IN:contractIds]){
            contractMap.put(e.Id, e.SBQQ__Quote__c );
        }
        Map<String,String> parentRecMap = new Map<String,String>();
        for(ContentDocumentLink cdl: Trigger.new){
            if(String.valueOf(cdl.LinkedEntityId).startsWith('800') ){ //Check if file is uploaded on contract object
                    ContentDocument CD = [select id,title from ContentDocument where id=:cdl.ContentDocumentId];system.debug('ContentDocument: '+CD.title);
                //Prevent the copie from contract to quote for two types of pdf - JIRA GFC-1361
                if(!CD.Title.contains('Completed') && !CD.Title.contains('completed'))
                
                {parentRecMap.put(cdl.ContentDocumentId, contractMap.get(cdl.LinkedEntityId));}//Map<ContentDocumentId,quoteId>
            }
            
        }
        List<ContentDocumentLink> cdl_List = new List<ContentDocumentLink>();
        
            for(String str: parentRecMap.keySet()){
                ContentDocumentLink cdl = new ContentDocumentLink(); // Content Document Link to share the file with Quote(Parent) record
                cdl.LinkedEntityId = parentRecMap.get(str); // Quote ID
                cdl.ContentDocumentId = str; //Content Dcoument ID
                cdl.ShareType = 'V';
                cdl.Visibility = 'InternalUsers';
                cdl_List.add(cdl);
                
            }
        
        system.debug('Size : '+ cdl_List);
        if(cdl_List.size()>0){
           insert cdl_List;// Insert Content Document Link to share the file with Quote 
        }
        //traitement des invoices
        List<blng__Invoice__c> invoices = [select id,Facture_Genere__c  from blng__Invoice__c where Id IN:invoicesIds limit 200];
        for(blng__Invoice__c invoice:invoices){
            invoice.Facture_Genere__c=true;
        }
        if(invoices.size()>0){
           update invoices;
        }
        //traitement des creditNotes
        List<blng__CreditNote__c> creditNotes = [select id,Facture_Genere__c  from blng__CreditNote__c where Id IN:creditNotesIds];
        for(blng__CreditNote__c creditNote:creditNotes){
            creditNote.Facture_Genere__c=true;
        }
        if(creditNotes.size()>0){
           update creditNotes;
        }
        //Traitement Orders
        List<Order> OrdersList = [Select id,status from order where Id IN:OrdersIds];
        for(Order O : OrdersList)
        {
            O.Status = 'Commande facturée';
        }
        if(OrdersList.size()>0){
            update OrdersList;}
    }
    }
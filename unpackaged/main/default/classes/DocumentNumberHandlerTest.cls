@isTest
private class DocumentNumberHandlerTest {
    
    @isTest static void CreateInvoiceNumberTest() { 
        
        SBQQ.TriggerControl.disable();

        Integer Sequence=8;
        // Create Documnet Number entry, set the sequence to 8
        Document_Number__c dn = new Document_Number__c(
		    Name ='Invoice',
            Year__c = String.valueOf(Date.Today().year()),
    		Company__c = 'CO',
    		Sequence__c = Sequence
		);
		insert dn;
 
        // Create 1 Test account
        Id accountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Compte_Client').getRecordTypeId();
        Account acc = Utils_TestMethods.createAccount('Test', 'Test', null, accountRTId);
        acc.Statut__c = 'Validé';
        insert acc;
        
        // Create 1 invoice record
        blng__Invoice__c inv = new blng__Invoice__c(blng__Account__c=acc.Id, blng__InvoiceDate__c=System.Today(), blng__InvoiceStatus__c='Draft');
		insert inv;
        
        // Create 2 invoice lineS 
        blng__InvoiceLine__c invline1 = new blng__InvoiceLine__c(blng__Invoice__c=inv.Id, Name = 'test', blng__InvoiceLineStatus__c='Draft', blng__TotalAmount__c =333);        
        blng__InvoiceLine__c invline2 = new blng__InvoiceLine__c(blng__Invoice__c=inv.Id, Name = 'test', blng__InvoiceLineStatus__c='Draft', blng__TotalAmount__c =333);
        insert new list<blng__InvoiceLine__c>{invline1,invline2 };
    	
        //get the date when Invoice was created
        blng__Invoice__c inv_result = [SELECT CreatedDate FROM blng__Invoice__c where Id=:inv.Id];
        
        String ExpectedInvoiceNumber=DocumentNumberHandler.FormatPostedNumber(inv_result.CreatedDate,'CO','L',Sequence); 
    
  	  	// Perform Test
        Test.startTest();
        
    	inv.blng__InvoiceStatus__c='Posted';
        update inv;   
        Test.stopTest();
    	
        //check that 1 Invoice is found with status 'Posted'
        List<blng__Invoice__c> verifyInvs = [SELECT Id, Posted_Invoice_Number__c FROM blng__Invoice__c where blng__InvoiceStatus__c='Posted'];
        System.assertEquals(1, verifyInvs.size()); //check #1
        
        //check that the Posted_Invoice_Number__c is properly populated
        System.assertEquals(ExpectedInvoiceNumber, verifyInvs[0].Posted_Invoice_Number__c); //check #2
        
        //check that Document_Number__c > Sequence__c field was increated to 9
        Document_Number__c dn_result = [select Id,Company__c,Sequence__c from Document_Number__c where  Name='Invoice' and Company__c='CO' limit 1];
        System.assertEquals(Sequence+1, dn_result.Sequence__c); //check #3
    }
    
    @isTest static void CreateCreditNoteNumberTest() { 
        
        Integer Sequence=8;
        // Create Document Number entry, set the sequence to 8
        Document_Number__c dn = new Document_Number__c(
		    Name ='CreditNote',
            Year__c = String.valueOf(Date.Today().year()),
    		Company__c = 'CO',
    		Sequence__c = Sequence
		);
		insert dn;
 
        // Create 1 Test account
        Id accountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Compte_Client').getRecordTypeId();
        Account acc = Utils_TestMethods.createAccount('Test', 'Test', null, accountRTId);
        acc.Statut__c = 'Validé';
        insert acc;
        
        //ProductS
		Product2 PRD1 = new Product2(Name = 'Product test 1' , IsActive = true , SBQQ__SubscriptionPricing__c = 'Fixed Price');
		insert PRD1;

        blng__CreditNote__c cn = new blng__CreditNote__c(blng__Account__c=acc.Id,blng__CreditNoteDate__c=Date.Today(),blng__Status__c='Draft', blng__CreditNoteSourceAction__c='Manual');
		insert cn;
        
        
        blng__CreditNoteLine__c cnl1 = new blng__CreditNoteLine__c(blng__CreditNote__c=cn.Id,blng__Product__c=PRD1.Id, blng__Subtotal__c=123.12);
        blng__CreditNoteLine__c cnl2 = new blng__CreditNoteLine__c(blng__CreditNote__c=cn.Id,blng__Product__c=PRD1.Id, blng__Subtotal__c=124.12);
        insert new List<blng__CreditNoteLine__c>{cnl1,cnl2};
    	
        //get the date when CreditNote was created
        blng__CreditNote__c cn_result = [SELECT CreatedDate FROM blng__CreditNote__c where Id=:cn.Id];
        
        
        //simulate what should be the posted number
        String ExpectedCreditNoteNumber=DocumentNumberHandler.FormatPostedNumber(cn_result.CreatedDate,'CO','A',Sequence); 
    
        // Perform Test
        Test.startTest();

        SBQQ.TriggerControl.disable();

//       	cn.blng__Status__c='Posted';
//        cn.blng__Notes__c='kornel test note';
//        update cn;
        // Create an approval request for the credit note
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(cn.Id);
        req1.setSubmitterId(UserInfo.getUserId());
        req1.setProcessDefinitionNameOrId('Posted_Credit_Note_Approval_Process');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        List<Id> newWorkItemIds = result.getNewWorkitemIds();

        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});

        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));

        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);

        //should add check on results, but it should pass the CN status to Posted
        
        Test.stopTest();

        
        List<blng__CreditNote__c> verifyCNs = [SELECT Id, Posted_CreditNote_Number__c FROM blng__CreditNote__c WHERE blng__Status__c = 'Posted'];
        System.assertEquals(1, verifyCNs.size()); //check #1
        
        system.debug('Posted_CreditNote_Number__c:'+verifyCNs[0].Posted_CreditNote_Number__c);
        system.debug('ExpectedCreditNoteNumber:'+ExpectedCreditNoteNumber);
        
        //check that the Posted_CreditNote_Number__c is properly populated
        System.assertEquals(ExpectedCreditNoteNumber, verifyCNs[0].Posted_CreditNote_Number__c); //check #2
        
        //check that Document_Number__c > Sequence__c field was increated to 9
        Document_Number__c dn_result = [select Id,Company__c,Sequence__c from Document_Number__c where  Name='CreditNote' and Company__c='CO' limit 1];
        System.assertEquals(Sequence+1, dn_result.Sequence__c); //check #3
    }
}
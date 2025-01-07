@isTest
public class ContentDocumentLink_Trigger_Test {
	 static testmethod void testmethod1(){
        Test.startTest();
        Account accA =new Account(Name='Demo');
        insert accA ;       
        SBQQ__Quote__c Q = New SBQQ__Quote__c();
        insert Q;  
        Contract C =new Contract(MasterContract__c=true,SBQQ__Quote__c=q.id,status='Draft',StartDate=system.Today(),AccountId=accA.Id);
        insert C;
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=c.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
               
        insert contentlink;
        List<ContentDocumentLink> myList=[SELECT id,(SELECT ContentDocumentId  FROM ContentDocumentLinks) FROM SBQQ__Quote__c ].ContentDocumentLinks;
        system.assertEquals(1, myList.size());
        Test.stopTest();
        
    }
}
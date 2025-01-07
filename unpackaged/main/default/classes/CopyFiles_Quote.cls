public class CopyFiles_Quote {

public static void CopyFileFromQuote(List<ContentDocumentLink> Initial_List)
{
    system.debug('Inside CopyFileFromQuote');
    List<ContentDocumentLink> CDL_List = new List<ContentDocumentLink>();
    List<ContentDocumentLink> CDL_List_Contract = new List<ContentDocumentLink>();
    List<ContentDocumentLink> CDL_List_MA = new List<ContentDocumentLink>();
    String Title ='';
    
    for(ContentDocumentLink cv:Initial_List)
    {
        if(cv.ContentDocumentId != null )
        {
            ContentDocument C = [select title,fileextension from ContentDocument where id=:cv.ContentDocumentId];
          
            if(C<>null)
            {
                if( C.title.left(2)=='FR' && C.FileExtension == 'pdf')
                {
                    CDL_List.add(cv);system.debug('CopyFileFromQuote Cond1 title :'+C.Title);
                }
                if (  C.title.left(17)==('Contrat simplifié') &&  C.title.contains('completed') && C.FileExtension == 'pdf' )
                {
                    CDL_List_Contract.add(cv);system.debug('Condition 2 accepted');
                }
                if((C.title.left(6)==('Master')|| C.title.left(3)==('MA ')) && (C.title.contains('completed')||C.title.contains('Completed')) && C.FileExtension == 'pdf')
                {
                    CDL_List_MA.add(cv);system.debug('Condition 3 accepted');
                }
            }
            
        }
    }
    
    if(CDL_List.size()>0 ){CopyFile_QuoteToFicheRenseignement(CDL_List);}
    if(CDL_List_Contract.size()>0){CopyFile_QuoteToContract(CDL_List_Contract);}
    if(CDL_List_MA.size()>0){CopyFile_QuoteToMA(CDL_List_MA);}
}
    
        
	public static void CopyFile_QuoteToFicheRenseignement(List<ContentDocumentLink> CDL_List)
    {

List<ContentDocumentLink> NEW_CDL_List = new List<ContentDocumentLink>();    
Map<ID,ID> TheMap = new Map<ID,ID>();  
        
        //Get fiche renseignement 
    
    for(ContentDocumentLink CDL : CDL_List)
    {
        List<Information_Sheet__c> ListFR = [select id from Information_Sheet__c where QUote__c=:CDL.LinkedEntityId];
        if(ListFR <> Null)
        {
            for(Information_Sheet__c Y : ListFR)
            {
                TheMap.put(CDL.ContentDocumentId, Y.id);// put (ContentDocument ID,FicheDeRenseignement ID)
            }
        }
    }
    
    for (Id key : TheMap.keySet()) {
 
    ContentDocumentLink NewCDL = new ContentDocumentLink();
        NewCDL.ContentDocumentId = key;
        NewCDL.LinkedEntityId=TheMap.get(key);
        NewCDL.ShareType='I';
        NewCDL.Visibility='InternalUsers';
        NEW_CDL_List.add(NewCDL);
	}
        try {
    Insert NEW_CDL_List;
} catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
   
    }
    
    public static void CopyFile_QuoteToContract(List<ContentDocumentLink> CDL_List)
    {

List<ContentDocumentLink> NEW_CDL_List = new List<ContentDocumentLink>();    
Map<ID,ID> TheMap = new Map<ID,ID>();  
String Contract_Number;      
        //Get contract by number
    
    for(ContentDocumentLink CDL : CDL_List)
    {
        
        ContentDocument CD = [select id,title from ContentDocument where id=:CDL.ContentDocumentId];
        
        Contract_Number = CD.Title.substringAfter('_').substringBefore('_');system.debug('Contrat number'+ Contract_Number);
        Contract Cont = [select id from Contract where ContractNumber=:Contract_Number];
        system.debug('Contract id : '+Cont.id);
        if(Cont.id <> null){TheMap.put(CDL.ContentDocumentId, Cont.id);}
        
    }
    
    for (Id key : TheMap.keySet()) {
 
    ContentDocumentLink NewCDL = new ContentDocumentLink();
        NewCDL.ContentDocumentId = key;system.debug('KEY: '+key);
        NewCDL.LinkedEntityId=TheMap.get(key);system.debug('Get KEY :'+TheMap.get(key));
        NewCDL.ShareType='I';
        NewCDL.Visibility='InternalUsers';
        NEW_CDL_List.add(NewCDL);
	}
        
     try {
    Insert NEW_CDL_List;
} catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
   
    }
    
    public static void CopyFile_QuoteToMA(List<ContentDocumentLink> CDL_List)
    {

List<ContentDocumentLink> NEW_CDL_List = new List<ContentDocumentLink>();    
Map<ID,ID> TheMap = new Map<ID,ID>();  
String Contract_Number;      
        //Get contract by number
    
    for(ContentDocumentLink CDL : CDL_List)
    {
        
        ContentDocument CD = [select id,title from ContentDocument where id=:CDL.ContentDocumentId];
        
        Contract_Number = CD.Title.substringAfter('_').substringBefore('_');system.debug('Contrat number'+ Contract_Number);
        Contract Cont = [select id from Contract where ContractNumber=:Contract_Number];
        system.debug('Contract id : '+Cont.id);
        TheMap.put(CDL.ContentDocumentId, Cont.id);
    }
    
    for (Id key : TheMap.keySet()) {
 
    ContentDocumentLink NewCDL = new ContentDocumentLink();
        NewCDL.ContentDocumentId = key;
        NewCDL.LinkedEntityId=TheMap.get(key);
        NewCDL.ShareType='I';
        NewCDL.Visibility='InternalUsers';
        NEW_CDL_List.add(NewCDL);
	}
    
      try {
    Insert NEW_CDL_List;
} catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
   
    }
}
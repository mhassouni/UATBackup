global class ExportAccountListBatch implements Database.Batchable<sObject>, Database.Stateful
{
    
    
    // Déclaration de la liste globale
   // global   List<Account> allAccounts = new List<Account>();
            private   List<Account> allAccounts = new List<Account>();

    
     global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        // Récupérer les informations sur les Record Types
        List<RecordType> recordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName IN ('Compte_Client', 'Prospect')];
     
        // Vérifier si les Record Types sont valides avant de construire la requête
        if (!recordTypes.isEmpty()) 
        {
            Set<Id> recordTypeIds = new Set<Id>();
            for (RecordType rt : recordTypes) 
            {
                recordTypeIds.add(rt.Id);
            }

           return Database.getQueryLocator('SELECT Id, Name, DB_DUNS_GU__c, DB_DUNS_DU__c, DB_DUNS_Number__c, ParentId, IS_Account_Child_of_GU__c, IS_Account_Child_of_DU__c, IS_Account_Child_of_Principal__c, Last_Flow_Update__c, PaysRegionPF__c, BillingCountry, Pays__c, Empreinte_Geographique__c FROM Account WHERE RecordTypeId IN :recordTypeIds');
        } 
        else 
        {
            // Gérer le cas où les Record Types ne sont pas valides
            return null;
    	}
		

    }

        global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        

		

    // Ajouter chaque élément du scope à la liste globale
 // Initialiser la liste allAccounts si elle est vide

    
    // Ajouter chaque élément du scope à la liste globale
    allAccounts.addAll(scope);                
//List<Account> allAccounts2 = new List<Account>();
  //      allAccounts2.addAll(scope);    
        String jsonLogText1 = JSON.serializePretty(allAccounts);
        Blob content1 = Blob.valueOf(jsonLogText1);
        String fileName1 =  'ExecuteallAccounts.json';
        // Créer un nouveau contenu de fichier
        ContentVersion contentVersion1 = new ContentVersion();
        contentVersion1.Title = fileName1;
        contentVersion1.PathOnClient = fileName1;
        contentVersion1.VersionData = content1;
        insert contentVersion1;
        Id contentDocumentId1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion1.Id].ContentDocumentId;
        ContentDocument contentDocument1 = [SELECT Id, Title FROM ContentDocument WHERE Id = :contentDocumentId1];
        }

    global void finish(Database.BatchableContext BC) 
    {
        // Actions à effectuer après l'exécution du lot
		
//if (allAccounts == null || allAccounts.isEmpty()) 
  //      {
    //        return;
      //  }
		
        // Filtrer les comptes qui sont à la fois parents et enfants
       
        

    // Lancez la classe Queueable avec les données nécessaires
    System.enqueueJob(new GeographicFootprintComputeAccounts(allAccounts), 5);        
        //GeographicFootprintComputeAccounts.computeGeographicFootprint(allAccounts);

    }
}
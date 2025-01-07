public class GeographicFootprintComputeAccounts implements Queueable 
{
     private List<Account> allAccounts;

    public GeographicFootprintComputeAccounts(List<Account> accountsToUpdate) {
        this.allAccounts = accountsToUpdate;
    }

    public void execute(QueueableContext context) {
         List<Account> ParentAccountsToUpdate = new List<Account>();
        List<Account> ChildAccountsToUpdate = new List<Account>();
        List<Account> AllAccountsToUpdate = new List<Account>();
        Map<Account, Map<String,Account>> ChildAccountMap = new Map<Account, Map<String,Account>>();
        Map<Account, Map<String,Account>> ParentAccountMap = new Map<Account, Map<String,Account>>();
        
        Account KeyAccount ;

        for (Account  ParentAccount: allAccounts)
        {
            Map<String,Account> ParentAccountMapLine = new  Map<String,Account>();
            for (Account  ChildAccount: allAccounts) 
            {
                //if( ( ChildAccount.DB_DUNS_GU__c == ParentAccount.DB_DUNS_Number__c ) && ( ChildAccount.DB_DUNS_GU__c != Null ) && (ParentAccount.DB_DUNS_Number__c != Null)   && (ParentAccount.Id != ChildAccount.Id) )
                if( ( ChildAccount.DB_DUNS_GU__c == ParentAccount.DB_DUNS_Number__c ) && ( ChildAccount.DB_DUNS_GU__c != Null ) && (ParentAccount.DB_DUNS_Number__c != Null) )
                {
                    //KeyList =  ParentAccount.Id;
                    KeyAccount =  ParentAccount;
                    if(ParentAccountMap.containsKey(KeyAccount))
                    {
                        ParentAccountMap.get(KeyAccount).put('GU : '+ ChildAccount.Id,ChildAccount);
                        
                    }
                    else 
                    {
                        ParentAccountMapLine.put('GU : '+ ChildAccount.Id,ChildAccount);
                        ParentAccountMap.put(KeyAccount, ParentAccountMapLine);
                    }
                }
                //if( ( ChildAccount.DB_DUNS_DU__c == ParentAccount.DB_DUNS_Number__c ) && (  ChildAccount.DB_DUNS_DU__c != Null ) && ( ParentAccount.DB_DUNS_Number__c != Null) && (ParentAccount.Id != ChildAccount.Id)  )
                if( ( ChildAccount.DB_DUNS_DU__c == ParentAccount.DB_DUNS_Number__c ) && (  ChildAccount.DB_DUNS_DU__c != Null ) && ( ParentAccount.DB_DUNS_Number__c != Null)  )
                {
                    
                    //KeyList = ParentAccount.Id;
                    KeyAccount = ParentAccount;
                    if(ParentAccountMap.containsKey(KeyAccount))
                    {
                        ParentAccountMap.get(KeyAccount).put('DU : '+ ChildAccount.Id,ChildAccount);
                    }
                    else 
                    {
                        ParentAccountMapLine.put('DU : '+ ChildAccount.Id,ChildAccount);
                        ParentAccountMap.put(KeyAccount, ParentAccountMapLine);
                    }
                }
                
                //if((ChildAccount.ParentId == ParentAccount.Id)  && (ParentAccount.Id != ChildAccount.Id) )
                if((ChildAccount.ParentId == ParentAccount.Id)  )
                {
                    
                    //KeyList = ParentAccount.Id;
                    KeyAccount = ParentAccount;
                    if(ParentAccountMap.containsKey(KeyAccount))
                    {
                        ParentAccountMap.get(KeyAccount).put('Principal : '+ ChildAccount.Id,ChildAccount);
                    }
                    else 
                    {
                        ParentAccountMapLine.put('Principal : '+ ChildAccount.Id,ChildAccount);
                        ParentAccountMap.put(KeyAccount, ParentAccountMapLine);
                    }
                }
                
            }
        }
        
        // Vérifier si ParentAccountMap n'est pas vide
        if (!ParentAccountMap.isEmpty()) 
        {
            // Itérer sur chaque compte parent dans ParentAccountMap
            for (Account parentAccount : ParentAccountMap.keySet()) 
            {
                // Récupérer les comptes enfants associés au compte parent
                Map<String, Account> childAccountsMap = ParentAccountMap.get(parentAccount);
                
                // Initialiser les variables de vérification
                Boolean Var_Is_R = true;
                Boolean Var_Is_N = true;
                Boolean Var_Is_I = true;
                
                // Itérer sur chaque compte enfant dans le sous-map
                for (String relationship : childAccountsMap.keySet()) 
                {
                    Account childAccount = childAccountsMap.get(relationship);
                    
                    // Vérifier les conditions pour les variables de vérification
                    //if ((parentAccount.PaysRegionPF__c != childAccount.PaysRegionPF__c)   && (ParentAccount.Id != ChildAccount.Id) )
                    if ((parentAccount.PaysRegionPF__c != childAccount.PaysRegionPF__c)  )
                    {
                        Var_Is_R = false;
                        //if ((parentAccount.BillingCountry != childAccount.Pays__c)  && (ParentAccount.Id != ChildAccount.Id) )
                        if ((parentAccount.BillingCountry != childAccount.Pays__c)   )
                        {
                            Var_Is_N = false;
                        }
                    }
                    
                }
                
                // Mettre à jour les champs Empreinte_Geographique__c et Last_Flow_Update__c en fonction des valeurs des variables de vérification
                DateTime currentDateTime = System.now();
                String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
                if (Var_Is_R) 
                {
                    parentAccount.Empreinte_Geographique__c = 'R';
                } 
                
                else if (Var_Is_N) 
                {
                    parentAccount.Empreinte_Geographique__c = 'N';
                }
                
                else 
                {
                    parentAccount.Empreinte_Geographique__c = 'I';
                }
                
                parentAccount.Last_Flow_Update__c = formattedDateTime;
                
                // Ajouter le compte parent à la liste des comptes à mettre à jour
                ParentAccountsToUpdate.add(parentAccount);
            }
        }

        for (Account   ChildAccount: allAccounts)
        {
            Map<String,Account> ChildAccountMapLine = new  Map<String,Account>();
            Boolean Var_IsGURecord = false;
            Boolean Var_IsDURecord = false;
            Boolean Var_IsPrincipalRecord = false;
            
            for (Account  ParentAccount: allAccounts) 
            {
                //if( ( ChildAccount.DB_DUNS_GU__c == ParentAccount.DB_DUNS_Number__c ) && ( ChildAccount.DB_DUNS_GU__c != Null ) && (ParentAccount.DB_DUNS_Number__c != Null)   && (ParentAccount.Id != ChildAccount.Id) )
                if( ( ChildAccount.DB_DUNS_GU__c == ParentAccount.DB_DUNS_Number__c ) && ( ChildAccount.DB_DUNS_GU__c != Null ) && (ParentAccount.DB_DUNS_Number__c != Null)  )
                {
                    Var_IsGURecord = true;
                    ChildAccount.Empreinte_Geographique__c = ParentAccount.Empreinte_Geographique__c;
                    KeyAccount =  ChildAccount;
                    if(ChildAccountMap.containsKey(KeyAccount))
                    {
                        ChildAccountMap.get(KeyAccount).put('GU : '+ ParentAccount.Id,ParentAccount);
                    }
                    else 
                    {
                        ChildAccountMapLine.put('GU : '+ ParentAccount.Id,ParentAccount);
                        ChildAccountMap.put(KeyAccount, ChildAccountMapLine);
                    }
                }
                //if( ( ChildAccount.DB_DUNS_DU__c == ParentAccount.DB_DUNS_Number__c ) && (  ChildAccount.DB_DUNS_DU__c != Null ) && ( ParentAccount.DB_DUNS_Number__c != Null)   && (ParentAccount.Id != ChildAccount.Id) )
                if( ( ChildAccount.DB_DUNS_DU__c == ParentAccount.DB_DUNS_Number__c ) && (  ChildAccount.DB_DUNS_DU__c != Null ) && ( ParentAccount.DB_DUNS_Number__c != Null) )
                {
                    
                    if(Var_IsGURecord == false)
                    {
                        Var_IsDURecord = true;
                        ChildAccount.Empreinte_Geographique__c = ParentAccount.Empreinte_Geographique__c;
                    }
                    KeyAccount = ChildAccount;
                    if(ChildAccountMap.containsKey(KeyAccount))
                    {
                        ChildAccountMap.get(KeyAccount).put('DU : '+ ParentAccount.Id,ParentAccount);
                    }
                    else 
                    {
                        ChildAccountMapLine.put('DU : '+ ParentAccount.Id,ParentAccount);
                        ChildAccountMap.put(KeyAccount, ChildAccountMapLine);
                    }
                }
                
                //if((ChildAccount.ParentId == ParentAccount.Id)   && (ParentAccount.Id != ChildAccount.Id) )
                if((ChildAccount.ParentId == ParentAccount.Id)  )
                {
                    
                    if(Var_IsGURecord == false && Var_IsDURecord == false)
                    {
                        Var_IsPrincipalRecord = true;
                        ChildAccount.Empreinte_Geographique__c = ParentAccount.Empreinte_Geographique__c;
                    }
                    KeyAccount = ChildAccount;
                    if(ChildAccountMap.containsKey(KeyAccount))
                    {
                        ChildAccountMap.get(KeyAccount).put('Principal : '+ ParentAccount.Id,ParentAccount);
                    }
                    else 
                    {
                        ChildAccountMapLine.put('Principal : '+ ParentAccount.Id,ParentAccount);
                        ChildAccountMap.put(KeyAccount, ChildAccountMapLine);
                    }
                }
            }
        }
        
        // Vérifier si ParentAccountMap n'est pas vide
        if (!ChildAccountMap.isEmpty()) 
        {
            DateTime currentDateTime = System.now();
            String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
            // Itérer sur chaque compte parent dans ParentAccountMap
            for (Account childAccount : ChildAccountMap.keySet()) 
            {
                childAccount.Last_Flow_Update__c = formattedDateTime;
                // Ajouter le compte parent à la liste des comptes à mettre à jour
                ChildAccountsToUpdate.add(childAccount);
            }
        }
        
        AllAccountsToUpdate = ChildAccountsToUpdate ;
        // Add records from accountsToUpdate to ChildAccountsToUpdate if they don't already exist
        if (!ParentAccountsToUpdate.isEmpty()) 
        {
            for (Account acc : ParentAccountsToUpdate) 
            {
                if (!AllAccountsToUpdate.contains(acc)) 
                {
                    AllAccountsToUpdate.add(acc);
                }
            }
            // Lancer le deuxième batch pour mettre à jour les enregistrements traités
        }

                Database.executeBatch(new GeographicFootprint_Batch(AllAccountsToUpdate));
               // GeographicFootprint_Batch batchJob = new GeographicFootprint_Batch(AllAccountsToUpdate);
                //GeographicFootprint_Batch batchJob = new GeographicFootprint_Batch(allAccounts);
                //Database.executeBatch(batchJob);
        
       /* String jsonLogText1 = JSON.serializePretty(AllAccountsToUpdate);
        Blob content1 = Blob.valueOf(jsonLogText1);
        String fileName1 =  'Finish_AllAccountsToUpdate.json';
        // Créer un nouveau contenu de fichier
        ContentVersion contentVersion1 = new ContentVersion();
        contentVersion1.Title = fileName1;
        contentVersion1.PathOnClient = fileName1;
        contentVersion1.VersionData = content1;
        insert contentVersion1;
        Id contentDocumentId1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion1.Id].ContentDocumentId;
        ContentDocument contentDocument1 = [SELECT Id, Title FROM ContentDocument WHERE Id = :contentDocumentId1];
*/
    }

}
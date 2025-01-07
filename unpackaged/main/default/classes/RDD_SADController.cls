public class RDD_SADController { 
    public Account accInit{get;set;}
    public SalesAreaData__c SADInit{get;set;}
    public Account accInitOpp{get;set;}
    public Account accInitCtr{get;set;}
    public Account accInitFact{get;set;}
    public Account accInitAct{get;set;}
    public Account accInitCondFi{get;set;}
    public Account accInitDERO{get;set;}
    public Account accInitTerritoire{get;set;}
    
    public String numberOfAccounts_InitSAD{get;set;}
    public String numberOfSAD_StatutSAD{get;set;}
    public String numberOfAccounts_InitSAD_Opp{get;set;}
    public String numberOfAccounts_InitSAD_Ctr{get;set;}
    public String numberOfAccounts_InitSAD_Fact{get;set;}
    public String numberOfAccounts_InitSAD_Act{get;set;}
    public String numberOfAccounts_InitSAD_CondFi{get;set;}
    public String numberOfAccounts_InitSAD_DERO{get;set;}
    public String numberOfAccounts_InitSAD_Territoire{get;set;}
    public String numberOfSegmentations{get;set;}
    
    public void init(){
        accInit=new account();
        accInitOpp=new account();
        accInitCtr=new account();
        accInitFact=new account();  
        accInitAct=new account();  
        accInitCondFi=new account();
        accInitDERO=new account();
        accInitTerritoire=new account();
        SADInit = new SalesAreaData__c();
        numberOfSAD_StatutSAD = 'nombre des SAD';
        numberOfAccounts_InitSAD='Nombre de comptes';     
        numberOfAccounts_InitSAD_Opp='Nombre d\'opportunités';  
        numberOfAccounts_InitSAD_Ctr='Nombre de contacts';  
        numberOfAccounts_InitSAD_Fact='Nombre de factures';  
        numberOfAccounts_InitSAD_Act='Nombre d\'activités';  
        numberOfAccounts_InitSAD_CondFi='Nombre de conditions financières';  
        numberOfAccounts_InitSAD_DERO='Nombre de dérogations';
        numberOfAccounts_InitSAD_Territoire='Nombre de SAD';
        numberOfSegmentations='Nombre de Segmentations';
        
    }
    
  /*RDD */
    /*Init SADs */
        /*Count Records*/
        /*************************************/
         
        /*Count ligible accounts for the RDD*/
        public void denombrerInitSAD(){
              String RecordtypeIdClient = Label.ACC_RecordTypeId_CompteClient;
            String RecordtypeIdProspect = Label.ACC_RecordTypeId_CompteProspect;
        string queryInitSAD='select Id,Name,CurrencyIsoCode,OwnerId,PaysRegionPF__c from Account where Pays__c <>null and Count_NB_SAD__c=0 and (RecordtypeId=:RecordtypeIdClient OR RecordtypeId=:RecordtypeIdProspect)  ' ;
                         
                        
        if(accInit.PaysRegionPF__c!=null && accInit.PaysRegionPF__c!=''){
            queryInitSAD+='and PaysRegionPF__c=\''+accInit.PaysRegionPF__c+'\' ';
        }
        queryInitSAD+= ' limit 50000';
        
        integer numAccsId=Database.query(queryInitSAD).size();
        numberOfAccounts_InitSAD=string.valueOf(numAccsId)+' comptes';
    }
        
        /*Count ligible SAD for the RDD*/
        public void denombrerStatutSAD(){
        string querystatutSAD='select Id,Name,PFRegion__c from SalesAreaData__c ' ;
         if(SADInit.PFRegion__c!=null && SADInit.PFRegion__c!=''){
            querystatutSAD+=' Where PFRegion__c=\''+SADInit.PFRegion__c+'\' ';
        }
            querystatutSAD+= ' limit 50000';
        integer numSADId=Database.query(querystatutSAD).size();
        numberOfSAD_StatutSAD=string.valueOf(numSADId)+' SAD';
    }
    
        /*Count ligible opportunities for the RDD */
        public void denombrerInitOppSAD(){
            integer nbOppsId;
            string queryInitOppSAD='select Id from Opportunity where SalesAreaData__c=null AND TypeProduits__c<>null AND AccountId<>Null ' ;
                         
                        
        if(accInitOpp.PaysRegionPF__c!=null && accInitOpp.PaysRegionPF__c!=''){
            queryInitOppSAD+='AND PaysRegionPF__c=\''+accInitOpp.PaysRegionPF__c+'\' ';
        }
     queryInitOppSAD+= ' limit 50000';
          
            nbOppsId=Database.query(queryInitOppSAD).size();
        
        numberOfAccounts_InitSAD_Opp=string.valueOf(nbOppsId)+' Opportunités';
    }
        
        /*Count ligible Factures véhicules for the RDD*/
        public void denombrerInitFacturesSAD(){
        string queryInitFactureSAD='select Id,Name,Parc__c,Compte__r.PaysRegionPF__c from Facture_vehicule__c where SalesAreaData__c=null  ' ;
                         
                        
        if(accInitFact.PaysRegionPF__c!=null && accInitFact.PaysRegionPF__c!=''){
            queryInitFactureSAD+=' AND Compte__r.PaysRegionPF__c=\''+accInitFact.PaysRegionPF__c+'\' ';
        }
           queryInitFactureSAD+= ' limit 50000';
        
        integer numAccsId=Database.query(queryInitFactureSAD).size();
        numberOfAccounts_InitSAD_Fact=string.valueOf(numAccsId)+' Factures';
    }
    
    /*Count ligible Contracts for the RDD*/
        public void denombrerContactsSAD(){
        string queryContractsSAD='select Id,AccountId from Contract where SalesAreaData__c=null  ' ;
         if(accInitCtr.PaysRegionPF__c!=null && accInitCtr.PaysRegionPF__c!=''){
            queryContractsSAD+=' and  Account.PaysRegionPF__c=\''+accInitCtr.PaysRegionPF__c+'\' ';
        }
             queryContractsSAD+= ' limit 50000';
        integer numContractsId=Database.query(queryContractsSAD).size();
        numberOfAccounts_InitSAD_Ctr=string.valueOf(numContractsId)+' Contacts';
    }
    
     /*Count ligible Conditions financières for the RDD*/
        public void denombrerCondFiSAD(){
        string queryCondFiSAD='select Id,SalesAreaData__c,Account__c,Account__r.PaysRegionPF__c from Dero_Fi__c where SalesAreaData__c=null and Account__r.PaysRegionPF__c<>null' ;
         if(accInitCondFi.PaysRegionPF__c!=null && accInitCondFi.PaysRegionPF__c!=''){
            queryCondFiSAD+=' AND Account__r.PaysRegionPF__c=\''+accInitCondFi.PaysRegionPF__c+'\' ';
        }
                 queryCondFiSAD+= ' limit 50000';
        integer numCondFisId=Database.query(queryCondFiSAD).size();
        numberOfAccounts_InitSAD_CondFi=string.valueOf(numCondFisId)+' CondFi';
    }
     
        /*Count ligible dérogations for the RDD*/
        public void denombrerDEROSAD(){
        string queryDeroSAD='select Id,SalesAreaData__c,Opportunite__c,Opportunite__r.SalesAreaData__c from Derogation__c where SalesAreaData__c=null and Opportunite__c<>null and Opportunite__r.SalesAreaData__c <>null' ;
         if(accInitDERO.PaysRegionPF__c!=null && accInitDERO.PaysRegionPF__c!=''){
            queryDeroSAD+=' AND Opportunite__r.PaysRegionPF__c=\''+accInitDERO.PaysRegionPF__c+'\' ';
        }
            queryDeroSAD+= ' limit 50000';
        integer numDerosId=Database.query(queryDeroSAD).size();
        numberOfAccounts_InitSAD_DERO=string.valueOf(numDerosId)+' Dérogations';
    }
    
        /*Count ligible SAD for the RDD*/
        public void denombrerTerritoire()
        {
        String queryTerritoireSAD = 'SELECT Id, SalesArea__c, PostalCode__c FROM SalesAreaData__c WHERE Secteur__c = null AND Territoire__c = Null and PostalCode__c <>null';
             if( accInitTerritoire.PaysRegionPF__c!=null && accInitTerritoire.PaysRegionPF__c!=''){
            queryTerritoireSAD+=' AND PFRegion__c=\''+accInitTerritoire.PaysRegionPF__c+'\' ';
        }
                        queryTerritoireSAD+= ' limit 10000';

            
        integer numTerritoiresId=Database.query(queryTerritoireSAD).size();
        numberOfAccounts_InitSAD_Territoire=string.valueOf(numTerritoiresId)+' SAD';
        }
    
    /*Count ligible Segmentation */
    public void denombrerSegmentation()
    {
        Integer numSegmentation = [SELECT COUNT()  FROM Segmentation__c];
        numberOfSegmentations = numSegmentation + ' Segmentations';
    } 
    
    
        /*Actions*/
        /*************************************/
    
        /*Action to launch Batch "RDD_InitSAD_Batch" */
        public void executeBatchIdInitSAD(){
        RDD_InitSAD_Batch batchInitSAD =new RDD_InitSAD_Batch(accInit.PaysRegionPF__c); 
        Database.executeBatch(batchInitSAD, 100);
        }
    
        /*Action to launch Batch "RDD_InitStatutSAD_Batch" */
        public void executeBatchIdInitStatutSAD(){
        RDD_InitStatutSAD_Batch batchInitStatutSAD =new RDD_InitStatutSAD_Batch(SADInit.PFRegion__c); 
        Database.executeBatch(batchInitStatutSAD, 100);
        }
    
        /*Action to launch Batch "RDD_InitoppSAD_Batch" */
        public void executeBatchIdInitOppSAD(){
        RDD_InitoppSAD_Batch batchInitOppsSAD =new RDD_InitoppSAD_Batch(accInitOpp.PaysRegionPF__c); 
        Database.executeBatch(batchInitOppsSAD, 100);
        }
                
        /*Action to launch Batch "RDD_InitFactureSAD_Batch" */
        public void executeBatchIdInitFactSAD(){
        RDD_InitFactureSAD_Batch batchInitFactsSAD =new RDD_InitFactureSAD_Batch(accInitFact.PaysRegionPF__c); 
        Database.executeBatch(batchInitFactsSAD, 100);
        }
    
        /*Action to launch Batch "RDD_InitContractsSAD_Batch" */
        public void executeBatchIdInitCtsSAD(){
        RDD_InitContractsSAD_Batch batchInitCtsSAD =new RDD_InitContractsSAD_Batch(accInitCtr.PaysRegionPF__c); 
        Database.executeBatch(batchInitctsSAD, 100);
        }
    
        /*Action to launch Batch "RDD_InitCondFiSAD_Batch" */
        public void executeBatchIdInitCondFiSAD(){
        RDD_InitCondFiSAD_Batch batchInitCtsSAD =new RDD_InitCondFiSAD_Batch(accInitCondFi.PaysRegionPF__c); 
        Database.executeBatch(batchInitctsSAD, 100);
        }
    
        /*Action to launch Batch "RDD_InitDEROSAD_Batch" */
        public void executeBatchIdInitDeroSAD(){
        RDD_InitDEROSAD_Batch batchInitDeroSAD =new RDD_InitDEROSAD_Batch(accInitDERO.PaysRegionPF__c); 
        Database.executeBatch(batchInitDeroSAD, 100);
        }
    
    
        /*Action to launch Batch "UpdateSalesAreaTerritoryDataBatch" */
        public void executeBatchIdInitTerritoire(){
        UpdateSalesAreaTerritoryDataBatch batchRDDTerritoire =new UpdateSalesAreaTerritoryDataBatch(accInitTerritoire.PaysRegionPF__c); 
        Database.executeBatch(batchRDDTerritoire, 200);
        }
    
        /*Action to launch Batch "Calculate Sector Overall Rating" */
        public void executeBatchSectorOverallRating()
        {
            CalculateSectorOverallRatingBatch batchSectorOverallRating =new CalculateSectorOverallRatingBatch(); 
            Database.executeBatch(batchSectorOverallRating, 200);
        }
    

        /*Action to launch Batch "SAD Segmentation Sync Batch" */
        public void executeBatchSADSegmentationSyncBatch()
        {
            SADSegmentationSyncBatch batchSADSegmentationSync =new SADSegmentationSyncBatch(0, accInitTerritoire.PaysRegionPF__c); 
            Database.executeBatch(batchSADSegmentationSync, 50);
        }
        
        /*Action to launch Batch "Account Segmentation Sync Batch" */
        public void executeBatchAccountSegmentationSyncBatch()
        {
            AccountSegmentationSyncBatch batchAccountSegmentationSync =new AccountSegmentationSyncBatch(0, accInitTerritoire.PaysRegionPF__c); 
            Database.executeBatch(batchAccountSegmentationSync, 50);
        }
                                
        /*Action to launch Batch "Account Segmentation Sync Batch" */
        public void executeBatchNotePoidsCABatch()
        {
            NotePoidsCABatch batchNotePoidsCABatch =new NotePoidsCABatch(); 
            Database.executeBatch(batchNotePoidsCABatch, 100);
        }
    
     	/*Action to launch Batch "Account Segmentation Sync Batch" */
        public void executeBatchEmployeeCountNoteUpdateBatch()
        {
            EmployeeCountNoteUpdateBatch batchEmployeeCountNoteUpdateBatch =new EmployeeCountNoteUpdateBatch(); 
            Database.executeBatch(batchEmployeeCountNoteUpdateBatch, 100);
        }
        
    
        /*RDD*/
        /*************************************/
    
        /*Init SAD per account*/
    public static void InitiateSADCreation(List<Account> ListAccounts,List<SalesArea__c> ListSA)
    {
        
        List<SalesAreaData__c> SADToCreate = new List<SalesAreaData__c>();
        
        for(Account AC : ListAccounts)
        {
            for(SalesArea__c SA : ListSA)
            {
                if(AC.Pays__c == SA.Country__c)
                {
                    SalesAreaData__c SAD = new SalesAreaData__c();
                    SAD.Account__c = AC.Id;
                    SAD.SalesArea__c= SA.Id;
                    String SADName = AC.Name.left(10)+' - '+SA.LegalEntity__r.Name+' - '+SA.Country__c +' - '+SA.BusinessLine__c ;
                    SAD.Name = SADName.left(80);
                    SAD.KeyAccountManager__c = AC.OwnerId;
                    SAD.TerritorialCommercial__c = AC.OwnerId;
                    SAD.PFRegion__c = AC.PaysRegionPF__c;
                    SAD.CurrencyIsoCode = AC.CurrencyIsoCode;
                    SADToCreate.add(SAD);
                }
            }
        }
        try{Insert SADToCreate;}Catch(Exception e){System.debug('Error insert SAD '+e.getMessage());}
        
    }
        /*Init Statut SAD*/
    public static void InitiateStatutSAD(List<SalesAreaData__c>ListeSAD)
    {
        List<SalesAreaData__c> SADToUpdate = new List<SalesAreaData__c>();
        
        for(SalesAreaData__c SAD : ListeSAD)
        {
            if(SAD.Opportunities__r.size()==0 && SAD.Contrats__r.size()==0)
            {
                SAD.AccountType__c = 'Prospect';
            }
            Else 
            {
                SAD.AccountType__c = 'Client';
            }
            SADToUpdate.add(SAD);

        }
         try{update SADToUpdate;}Catch(Exception e){System.debug('Error Update statut SAD '+e.getMessage());}
    }    
        /*Migrate Opps SAD*/
    public static void MigrateOppsSAD(List<Opportunity>ListeOpps,List<SalesAreaData__c> ListeSAD)
    {
        
        List<Opportunity> OppsToUpdate = new List<Opportunity>();
        
        for(Opportunity OPP : ListeOpps)
        {
           
           //Migration Logic
           for(SalesAreaData__c SAD : ListeSAD)
           {
               if(OPP.AccountId==SAD.Account__c)
               {
                  //France and VF
                   if( ((OPP.PaysRegionPF__c).left(4) == 'DRO ' || (OPP.PaysRegionPF__c == 'STFR')) &&  OPP.TypeProduits__c == 'Véhicules Frigorifiques')
                   {
                     
                       //Traitement cas spécial France VF
                       if((OPP.PaysRegionPF__c).left(4) == 'DRO ' && SAD.LegalEntityName__c=='Petit Forestier Location' && SAD.BusinessLine__c=='Véhicules Frigorifiques')
                       {
                           OPP.SalesAreaData__c = SAD.Id;OppsToUpdate.add(OPP);Break;
                       }
                       else if((OPP.PaysRegionPF__c).left(4) == 'STFR ' && SAD.LegalEntityName__c=='Stricher Froid' && SAD.BusinessLine__c=='Véhicules Frigorifiques')
                       {
                           OPP.SalesAreaData__c = SAD.Id;OppsToUpdate.add(OPP);Break;
                       }
                   }
                   //not(France & VF)
                   else
                   {
                       //traitement par type de produit
                       if(OPP.TypeProduits__c == SAD.BusinessLine__c)
                       {
                           OPP.SalesAreaData__c= SAD.Id;OppsToUpdate.add(OPP);
                           Break; // Break from the inner loop
                       }
                   }
               }
               
               
               
           
           }
            

        }
         try{update OppsToUpdate;}Catch(Exception e){System.debug('Error Update statut SAD '+e.getMessage());}
    }
        /*Migrate Factures SAD*/
    public static void MigrateFacturesSAD(List<Facture_vehicule__c>ListeFactures,List<SalesAreaData__c> ListeSAD)
    {
        
        List<Facture_vehicule__c> FactsToUpdate = new List<Facture_vehicule__c>();
        
        for(Facture_vehicule__c Fact : ListeFactures)
        {
           for(SalesAreaData__c SAD : ListeSAD)
           {
               if(FACT.Compte__c == SAD.Account__c && FACT.N_Parc__c <>null && (FACT.N_Parc__c).Contains('ST-') && SAD.BusinessLine__c=='Véhicules Secs' )
               {
                   FACT.SalesAreaData__c = SAD.id; 
                   FactsToUpdate.add(Fact);break;
               }
               else if (FACT.Compte__c == SAD.Account__c && (FACT.N_Parc__c <>null ) && (FACT.N_Parc__c).contains('PF-') && SAD.businessLine__c=='Véhicules frigorifiques' && (SAD.LegalEntityName__c).contains('Petit Forestier'))
               {
                   FACT.SalesAreaData__c = SAD.id; 
                   FactsToUpdate.add(Fact);break;
               }
               else if (FACT.Compte__c == SAD.Account__c && (FACT.N_Parc__c==NULL ||( !(FACT.N_Parc__c).Contains('ST-') && !(FACT.N_Parc__c).Contains('PF-') )) &&  SAD.BusinessLine__c=='Véhicules frigorifiques' && (SAD.LegalEntityName__c).contains('Petit Forestier'))
               {
                   
                    FACT.SalesAreaData__c = SAD.id; 
                    FactsToUpdate.add(Fact);break;
                 
               }
               
           }
           
           
        }
           

        
         try{
             if(FactsToUpdate.size()<>0) {update FactsToUpdate;}
         }Catch(Exception e){System.debug('Error Update statut SAD '+e.getMessage());}
    }
        /*Migrate Contrats SAD*/
     public static void MigrateContratsSAD(List<Contract>ListeContrats,List<SalesAreaData__c> ListeSAD)
    {
        
        List<Contract> CtssToUpdate = new List<Contract>();
        
        for(Contract ct : ListeContrats)
        {
           for(SalesAreaData__c SAD : ListeSAD)
           {
               if(ct.AccountId == SAD.Account__c && ct.recordtypeId<>Label.RecordtypeId_ContratVehicule && SAD.BusinessLine__c == 'Containers')
               {
                  ct.SalesAreaData__c = SAD.id;CtssToUpdate.add(ct);break;
                       
               }
               else if(ct.AccountId == SAD.Account__c && ct.recordtypeId ==Label.RecordtypeId_ContratVehicule && ct.Actif__c<>null )
               {
                   if( ct.Actif__r.Name<>null && (ct.Actif__r.Name).left(2)=='ST' &&  SAD.BusinessLine__c == 'Véhicules secs' && (SAD.LegalEntityName__c).contains('Zefirent'))
                   {
                          ct.SalesAreaData__c = SAD.id;CtssToUpdate.add(ct);break;
                   }
                   else if ( (ct.Actif__r.Name==null || (ct.Actif__r.Name).left(2)=='PF') &&  SAD.BusinessLine__c == 'Véhicules Frigorifiques' && (SAD.LegalEntityName__c).contains('Petit Forestier'))
                   {
                         ct.SalesAreaData__c = SAD.id;CtssToUpdate.add(ct);break;
                   }
               }
           }
           
          
        }
           

        
         try{
             if(CtssToUpdate.size()<>0)
                {
                    update CtssToUpdate;
                }
         }Catch(Exception e){System.debug('Error Update statut SAD '+e.getMessage());}
    }
        /*Migrate Conditions financières SAD*/
    public static void MigrateCondFiSAD(List<Dero_Fi__c>ListeCondFi,List<SalesAreaData__c> ListeSAD)
    {
        list<Dero_Fi__c> listeCondFiToUpdate = new list<Dero_Fi__c>();
        for(Dero_Fi__c D : ListeCondFi)
        {
            for(SalesAreaData__c SAD : ListeSAD)
            {
                if(D.Account__c == SAD.Account__c && SAD.BusinessLine__c=='Containers')
                {
                    D.SalesAreaData__c = SAD.ID;
                    D.SalesArea__c = SAD.SalesArea__c;
                    listeCondFiToUpdate.add(D);break;
                }
            }
        }
        
         try{
             if(listeCondFiToUpdate.size()<>0)
                {
                    update listeCondFiToUpdate;
                }
         }Catch(Exception e){System.debug('Error Migrate CondFI '+e.getMessage());}
        
        
    }
        /*Migrate Derogations SAD*/
      public static void MigrateDeroSAD(List<derogation__c>ListeDero)
    {
        list<Derogation__c> listeDerosToUpdate = new list<Derogation__c>();
        for(Derogation__c D : ListeDero)
        {
           D.SalesAreaData__c = D.Opportunite__r.SalesAreaData__c;
           listeDerosToUpdate.add(D);
        }
        system.debug('Taille listeDerosToUpdate : '+listeDerosToUpdate);
         try{
             if(listeDerosToUpdate.size()<>0)
                {
                    update listeDerosToUpdate;
                }
         }Catch(Exception e){System.debug('Error Migrate CondFI '+e.getMessage());}
        
        
    }
    
    /*Get SAD of an opportunity 
     */ 
      @InvocableMethod (label = 'Get The SAD for Opp' description = 'return the SAD of the opportunity')
    public static list<SalesAreaData__c> MigrateOneOpportunity(List<ID> ids)
{
    String OpportunityId = ids[0];system.debug('ids : '+ids[0]);
    list<SalesAreaData__c> listeSAD =new list<SalesAreaData__c>();
    Opportunity OPP = [select id,AccountId,SalesAreaData__c,PaysRegionPF__c,TypeProduits__c from Opportunity where id=:OpportunityId limit 1];
    List<SalesAreaData__c> SADs = [Select id,BusinessLine__c,LegalEntityName__c from SalesAreaData__c where account__c = :OPP.AccountId];
    //Migration Logic
           for(SalesAreaData__c SAD : SADs)
           {
              
                  //France and VF
                   if( ((OPP.PaysRegionPF__c).left(4) == 'DRO ' || (OPP.PaysRegionPF__c == 'STFR')) &&  OPP.TypeProduits__c == 'Véhicules Frigorifiques')
                   {
                     
                       //Traitement cas spécial France VF
                       if((OPP.PaysRegionPF__c).left(4) == 'DRO ' && SAD.LegalEntityName__c=='Petit Forestier Location' && SAD.BusinessLine__c=='Véhicules Frigorifiques')
                       {
                          listeSAD.Add(SAD);break;
                       }
                       else if((OPP.PaysRegionPF__c).left(4) == 'STFR ' && SAD.LegalEntityName__c=='Stricher Froid' && SAD.BusinessLine__c=='Véhicules Frigorifiques')
                       {
                          listeSAD.Add(SAD);break;
                       }
                   }
                   //not(France & VF)
                   else
                   {
                       //traitement par type de produit
                       if(OPP.TypeProduits__c == SAD.BusinessLine__c)
                       {
                          listeSAD.Add(SAD);break; 
                       }
                   }
               }
    return listeSAD;
   
}
}
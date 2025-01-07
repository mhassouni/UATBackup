@isTest
private class QuoteClass_TEST {
Static testMethod void generateTarificationsTest()
{
    Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
    MyBypass.BypassValidationRules__c = true;
    insert MyBypass;
  
    //OPP
    Account ACC = Utils_TestMethods.createAccount('accName', 'accCodeNAF', null, Label.CPT_RecordTypeId_CompteClient);
    Date dd = Date.newInstance(2020,9,1);
    Opportunity  OPP = Utils_TestMethods.createOpportunity('oppName', '2 - Opportunité qualifiée',dd , ACC);
    insert OPP;
  
    //Quote
    Quote Q = new Quote();
    Q.Name='TEST';
    Q.OpportunityId=OPP.Id;
    Q.CurrencyIsoCode = 'EUR';
    Q.Duree_de_location__c = '24;48';
    Q.Kilom_trage__c=2000;
    Q.RecordTypeId=Label.Quote_RecordTypeId_Parc;
    insert Q;
    
    //Générer les lignes de tarification à l'insertion
    QuoteClass.generateTarifications(Q.Id,Q.CurrencyIsoCode);
    //Générer les lignes de tarification à l'update
    Q.Duree_de_location__c = '36;69';
    Q.Kilom_trage__c=2300;
    update Q;
}
  Static testMethod void generateTarificationsTriggerTest()
  {
    Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
    MyBypass.BypassValidationRules__c = true;
    insert MyBypass;
      
    //Quote  
        Quote Q = new Quote();
        Account ACC = Utils_TestMethods.createAccount('accName', 'accCodeNAF', null, Label.ACC_RecordTypeId_CompteClient);
        ACC.statut__c = 'Validé';ACC.IDEulerHermes__c='12344';ACC.Ligne1__c='Rue';ACC.CodePostal__c='12345';ACC.Ville__c='Paris';ACC.Pays__c='France';
        insert ACC;
        Contact Cont = Utils_TestMethods.createContact('conName', ACC.id);
        insert Cont;
        Date dd = Date.newInstance(2020,9,1);
        Opportunity  OPP = Utils_TestMethods.createOpportunity('oppName', '2 - Opportunité qualifiée',dd , ACC);
        insert OPP;
        Q.Duree_de_location__c='24;48';
        Q.Kilom_trage__c=2000;
        Q.OpportunityId =OPP.id;
        Q.RecordTypeId=Label.Quote_RecordTypeId_Parc;
        Q.Name='TEST';
        Q.Type_de_produit__c='Véhicules Frigorifiques';
        Q.Sous_famille__c ='CF';
        Q.Categorie__c='CF10';
        Q.Sous_Categorie__c='CF10';
        Q.Quantite__c=1;
        Q.Duree__c=24;
        Q.Loyer__c =200;
        Q.KM__c = 3000;
        Q.Origine_de_produit__c='A';
    insert Q;
      
    //Second Quote
        Quote Q2 = new Quote();
        Q2.Duree_de_location__c='24;48';
        Q2.Kilom_trage__c=2000;
        Q2.OpportunityId =OPP.id;
        Q2.RecordTypeId=Label.Quote_RecordTypeId_Parc;
        Q2.Name='TEST2';
        Q2.Type_de_produit__c='Véhicules Frigorifiques';
        Q2.Sous_famille__c ='CF';
        Q2.Categorie__c='CF10';
        Q2.Sous_Categorie__c='CF10';
        Q2.Quantite__c=1;
        Q2.Duree__c=24;
        Q2.Loyer__c =200;
        Q2.KM__c = 3000;
        Q2.Origine_de_produit__c='A';
        //Q2.Synchronise__c=true;
        insert Q2;
        
        //Update Quote
        Q.Duree_de_location__c='24;48';
        Q.Kilom_trage__c=4800;
        update Q;
        //Q.Synchronise__c=true;
        update Q;
      
      //Third Quote
        Quote Q3 = new Quote();
        Q3.Duree_de_location__c='24;48';
        Q3.Kilom_trage__c=2000;
        Q3.OpportunityId =OPP.id;
        Q3.RecordTypeId=Label.Quote_RecordTypeId_Parc;
        Q3.Name='TEST2';
        Q3.Type_de_produit__c='Véhicules Frigorifiques';
        Q3.Sous_famille__c ='CF';
        Q3.Categorie__c='CF10';
        Q3.Sous_Categorie__c='CF10';
        Q3.Quantite__c=1;
        Q3.Duree__c=24;
        Q3.Loyer__c =200;
        Q3.KM__c = 3000;
        Q3.Origine_de_produit__c='A';
       // Q3.Synchronise__c=true;
        insert Q3;
        
        //Update Quote
        Q3.Duree_de_location__c='12;24';
        Q3.Kilom_trage__c=4800;
        update Q3;
        //Q3.Synchronise__c=true;
        //update Q3;
      
      //Forth Quote
        Quote Q4 = new Quote();
        Q4.Duree_de_location__c='24;48';
        Q4.Kilom_trage__c=2000;
        Q4.OpportunityId =OPP.id;
        Q4.RecordTypeId=Label.Quote_RecordTypeId_Parc;
        Q4.Name='TEST2';
        Q4.Type_de_produit__c='Véhicules Frigorifiques';
        Q4.Sous_famille__c ='CF';
        Q4.Categorie__c='CF10';
        Q4.Sous_Categorie__c='CF10';
        Q4.Quantite__c=1;
        Q4.Origine_de_produit__c='A';
        //Q4.Synchronise__c=true;
        insert Q4;
        
        //Update Quote
        
        update Q4;
        Q4.Duree__c=24;
        Q4.Loyer__c =200;
        Q4.KM__c = 3000;
        Q4.Synchronise__c=true;
        Q4.Prix_du_km_supplementaire_les_100_kms__c=10;
        //update Q4;
  }
}
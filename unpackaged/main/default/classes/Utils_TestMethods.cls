@isTest
public class Utils_TestMethods{

    public static Account CreateAgence(String AgenceName)
    {
        return new Account(Name=AgenceName,RecordTypeId=Label.ACC_RT_AgencePF);
    }
    public static Asset CreateAsset(Id Account_ID,Id RecordType)
    {
        return new Asset(AccountId =Account_ID,Name='Parc TEST',RecordTypeId=RecordType );
    }
    public static Account createAccount(string accName, string accCodeNAF, string accParent, string accRecordTypeId){
        return new Account( Name=accName, CodeNAF__c=accCodeNAF, ParentId=accParent, RecordTypeId = accRecordTypeId,PaysRegionPF__c='DO1B',AgencePF__c='001 - VILLEPINTE');
    }
    public static Account createAccount_Concurrent(string accName, string accCodeNAF, string accParent, string accRecordTypeId,string Pays){
        return new Account( Name=accName, CodeNAF__c=accCodeNAF, ParentId=accParent, RecordTypeId = accRecordTypeId,TECHPaysOperation__c= Pays,Types_Produits_Concurrent__c='Véhicules Frigorifiques' );
    }
    public static Account createAccount_withPays(string accName, string accCodeNAF, string accParent, string accRecordTypeId,string Pays){
        return new Account( Name=accName, CodeNAF__c=accCodeNAF, ParentId=accParent, RecordTypeId = accRecordTypeId,TECHPaysOperation__c= Pays,Types_Produits_Concurrent__c='Véhicules Frigorifiques' );
    }
    public static Account createAccountForTax(String accName, String numeroTVAIntracom, String billingCountry, String accRecordTypeId)
    {
        return new Account( Name=accName,  NumeroTVAIntracom__c  = numeroTVAIntracom, BillingCountry = billingCountry, Pays__c = billingCountry, RecordTypeId = accRecordTypeId);
    }
    
    public static RoleContact__c createRoleContact(string rcContact, string rcOpportunity, string rcAccount){
        return new RoleContact__c(Contact__c=rcContact, Opportunite__c=rcOpportunity, CompteOpportunite__c=rcAccount);
    }

    
    public static User createUser(string lastName, string userAlias, string userProfileId){
        return new User(alias=userAlias, email=userAlias + '@test.com', emailencodingkey='UTF-8', lastname=lastName, languagelocalekey='en_US', localesidkey='en_US', profileid = userProfileId, timezonesidkey='America/Los_Angeles', username= userAlias + '@test.com');
    }
    /*public static User createUserdirectiongenerale(string lastName, string userAlias, string userProfileId, string userRoleId_DG){
        return new User(alias=userAlias, email='mhassouni@petitforestier.fr', emailencodingkey='UTF-8', lastname=lastName, languagelocalekey='en_US', localesidkey='en_US', profileid = userProfileId, timezonesidkey='America/Los_Angeles', username= userAlias + '@test.com', userRoleId = userRoleId_DG);
    }*/
    
    public static Opportunity createOpportunity(string oppName, string oppStage, date oppCloseDate, Account oppAccount){
        return new Opportunity(Name=oppName, StageName=oppStage, CloseDate=oppCloseDate, AccountId=(oppAccount!=null?oppAccount.Id:null),Probabilite_signature__c='20% (Peu probable)',Sans_Concurrent__c =true);
    }
     
     public static Opportunity createOpportunityWithRegion(string oppName, string oppStage, date oppCloseDate, Account oppAccount,string region){
        return new Opportunity(Name=oppName, StageName=oppStage, CloseDate=oppCloseDate, AccountId=(oppAccount!=null?oppAccount.Id:null),PaysRegionPF__c=region,Probabilite_signature__c='20% (Peu probable)',Sans_Concurrent__c =true);
    }
     public static Opportunity createOpportunityWithProduits(string oppName, string oppStage, date oppCloseDate, Account oppAccount){
        return new Opportunity(Name=oppName, StageName=oppStage, CloseDate=oppCloseDate, AccountId=(oppAccount!=null?oppAccount.Id:null),Probabilite_signature__c='20% (Peu probable)',TypeProduits__c ='Véhicules Frigorifiques',Sans_Concurrent__c =true);
    }
 /*   public static PropositionCommerciale__c createPropositionCommerciale(String pcOpportunite, Date pcDateRemise, string pcRaison){
        return new PropositionCommerciale__c(Opportunite__c=pcOpportunite, DateRemise__c=pcDateRemise, Raison__c=pcRaison);
    }*/
    
 /*   public static Task createTask(string tasWhatId, string tasSubject, string tasTypeProduit){
        return new Task(WhatId=tasWhatId, Subject=tasSubject, TypeProduits__c = tasTypeProduit);
    }*/
    
    public static Event createEvent(string evnWhatId, string evnSubject, string evnTypeProduit, integer evenDurationInMinutes, Datetime evnActivityDateTime){
        return new Event(Type_lieu__c='Site PF',WhatId=evnWhatId, Subject=evnSubject, TypeProduits__c = evnTypeProduit, DurationInMinutes = evenDurationInMinutes, ActivityDateTime = evnActivityDateTime);
    }
    
 /*   public static Lead createLead(string ldCompany, string ldLastName){
        return new Lead(Company=ldCompany, LastName=ldLastName);
    }*/
    
    public static Relation__c createRelation(string relContactPrincipal, string relContactRelie, string relTypeRelation){
        return new Relation__c(ContactPrincipal__c=relContactPrincipal, ContactRelie__c=relContactRelie, TypeRelation__c=relTypeRelation);
    }
    
    public static Contact createContact(string conName, string accParent){
        return new Contact(LastName=conName, AccountId=accParent);
    }
    
    public static Bypass__c createBypass(string bypSetupOwnerId){
        return new Bypass__c(SetupOwnerId=bypSetupOwnerId);
    }
    
   /* public static Produit__c createProduit(string proOpportunty, integer proDureeContrat, integer proLoyerMensuel, integer proQuantite ){
        return new Produit__c(Opportunite__c = proOpportunty, DureeContrat__c = proDureeContrat,LoyerMensuel__c = proLoyerMensuel,Quantite__c = proQuantite);
    }*/
    
    public static OpportunityTeamMember createOpportunityTeamMember(string otmUserId, string otmTeamMemberRole, string otmOpportunityId){
        return new OpportunityTeamMember(UserId = otmUserId, TeamMemberRole = otmTeamMemberRole, OpportunityId = otmOpportunityId);
    }
    
 /*   public static FicheDecouverte__c createFicheDecouverte(string fdcAccountId){
        return new FicheDecouverte__c(CompteRaisonSociale__c = fdcAccountId);
    }*/
    
    /*public static Event createEvent(Id relatedTo, Integer eventDuration, DateTime eventDateTime){
        return new Event(WhatId=relatedTo, DurationInMinutes=eventDuration, ActivityDateTime=eventDateTime);
    }
    
    public static OpportunityContactRole createOpportunityContactRole(Id oppId, Id conId, string contactRole){
        return new OpportunityContactRole(OpportunityId=oppId, ContactId=conId, Role=contactRole);
    }
    
    public static OpportunitySplit createOpportunitySplit(Id oppId, Id owner_Id){
        return new OpportunitySplit(OpportunityId = oppId, SplitOwnerId = owner_Id);
    }
    
    public static OBS__c createOBS(String unitCode, String nameObs, Id owner_id, String level, String status){
        return new OBS__c(UnitCode__c = unitCode, Name = nameObs, OwnerId = owner_id, level__c = level, Status__c = status);//, Owner = owner_id
    }
    
    public static Competitor_Partner__c createCompetitorPartner(string compName){
        return new Competitor_Partner__c(Name=compName);
    }
    
    public static Competition__c createCompetition(Id oppId, Id compId, String finalDecision){
        return new Competition__c(Opportunity__c=oppId, Competitor__c=compId, FinalDecision__c=finalDecision);
    }
    
    public static SetupTable__c createSetupTable(Id divisionId, Integer Margin1, Integer Margin2, String Level1, String Level2){
        return new SetupTable__c(Division__c=divisionId, MarginPercentApprover1__c=Margin1, MarginPercentApprover2__c=Margin2, LevelApprover1__c=Level1, LevelApprover2__c=Level2);
    }
    
    public static Territory2 createTerritory(string territoryName){
        return new Territory2(Name=territoryName);
    }
    
    public static UserTerritory__c createUserTerritory(string userTerritoryName, boolean active){
        return new UserTerritory__c(Name=userTerritoryName, Active__c=active);
    }
    
    public static User_Territory_Account__c createUserTerritoryAccount(Id userTerritoryId, Id accountId){
        return new User_Territory_Account__c(UserTerritory__c=userTerritoryId, Account__c=accountId);
    }
    
    public static UserTerritory2Association createUserTerritory2Association(Id terrId, Id userId, string roleInTerr){
        return new UserTerritory2Association(Territory2Id=terrId, UserId=userId, RoleInTerritory2=roleInTerr);
    }
    
    public static AccessRequest__c createAccessRequest(Id accId, Id userId, string status){
        return new AccessRequest__c(Account__c=accId, Submitter__c=userId, Status__c=status);
    }*/
    
 /*   public static PotentielVehiculesFrigorifiques__c Create_Potentiel_Frigo(ID RaisonSociale,String Classement,string Cat_produit,string Sous_cat_produit,string Type_carrosserie,integer Quantite,string Type_sourcing,string Due_Date)
    {
        //Date MyDate=date.newInstance(Due_Date.year(), Due_Date.month(), Due_Date.day());
        Date MyDate = date.parse(Due_Date);
        return new PotentielVehiculesFrigorifiques__c(CompteRaisonSociale__c=RaisonSociale,Classement__c=Classement,CategorieProduit__c=Cat_produit,SousCategorieProduit__c=Sous_cat_produit,TypeCarrosserie__c=Type_carrosserie,Quantite__c=Quantite,TypeSourcing__c=Type_sourcing,DateEcheance__c=MyDate);
    }
     public static PotentielVehiculesSecs__c Create_Potentiel_Sec(ID RaisonSociale,String Classement,string Cat_produit,string Sous_cat_produit,string Type_carrosserie,integer Quantite,string Type_sourcing,string Due_Date)
    {
        //Date MyDate=date.newInstance(Due_Date.year(), Due_Date.month(), Due_Date.day());
        Date MyDate = date.parse(Due_Date);
        return new PotentielVehiculesSecs__c(CompteRaisonSociale__c=RaisonSociale,Classement__c=Classement,CategorieProduit__c=Cat_produit,SousCategorieProduit__c=Sous_cat_produit,TypeCarrosserie__c=Type_carrosserie,Quantite__c=Quantite,TypeSourcing__c=Type_sourcing,DateEcheance__c=MyDate);
    }
      public static PotentielContainers__c Create_Potentiel_Container(ID RaisonSociale,String Classement,string Cat_produit,string Sous_cat_produit,string Type_carrosserie,integer Quantite,string Type_sourcing,string Due_Date)
    {
        //Date MyDate=date.newInstance(Due_Date.year(), Due_Date.month(), Due_Date.day());
        Date MyDate = date.parse(Due_Date);
        return new PotentielContainers__c(CompteRaisonSociale__c=RaisonSociale,Classement__c=Classement,CategorieProduit__c=Cat_produit,SousCategorieProduit__c=Sous_cat_produit,TypeCarrosserie__c=Type_carrosserie,Quantite__c=Quantite,TypeSourcing__c=Type_sourcing,DateEcheance__c=MyDate);
    }
     public static PotentielMeubles__c Create_Potentiel_Meuble(ID RaisonSociale,String Classement,string Cat_produit,string Sous_cat_produit,string Type_carrosserie,integer Quantite,string Type_sourcing,string Due_Date)
    {
        //Date MyDate=date.newInstance(Due_Date.year(), Due_Date.month(), Due_Date.day());
        Date MyDate = date.parse(Due_Date);
        return new PotentielMeubles__c(CompteRaisonSociale__c=RaisonSociale,Classement__c=Classement,CategorieProduit__c=Cat_produit,SousCategorieProduit__c=Sous_cat_produit,TypeCarrosserie__c=Type_carrosserie,Quantite__c=Quantite,TypeSourcing__c=Type_sourcing,DateEcheance__c=MyDate);
    }*/
   
    public static Case CreateCase_Depannage(ID Compte,ID Parc,ID AgenceIntervenante,ID RecordType)
    {
		return new Case(AccountId=Compte,AssetId=Parc,Agence_intervenante__c=AgenceIntervenante,RecordTypeId=RecordType);
    }
        
    public static WorkOrder CreateWorkOrder_Depannage(ID compte,Id Parc,Id AgenceIntervenante,Id TheCase,Id RecordType)
    {
        return new WorkOrder(AccountId=compte,AssetId=Parc,Agence_Intervenante__c=AgenceIntervenante,CaseId=TheCase,RecordTypeId=RecordType);
    }
    
    public static  blng__TaxRule__c createTaxRule(String name)
    {
        return new blng__TaxRule__c(Name = name);
    }
    
    public static  blng__TaxIntegration__c createTaxIntegration(String name, Boolean active)
    {
        return new blng__TaxIntegration__c(Name = name, blng__Active__c = active);
    }
    
    public static  blng__TaxTreatment__c createTaxTreatment(String name, String taxRule, String taxIntegration )
    {
        return new blng__TaxTreatment__c(Name = name, blng__TaxRule__c = taxRule, blng__TaxIntegration__c = taxIntegration );
    }
   
    public static Product2 createProduct(String name, Boolean isActive)
    {
        return new Product2(Name = name , IsActive = isActive);
    }
    
    public static PricebookEntry createPricebookEntry(String pricebook2Id, String product2Id, Decimal  unitPrice, Boolean isActive)
    {
        return new PricebookEntry(Pricebook2Id = pricebook2Id , Product2Id = product2Id, UnitPrice = unitPrice, IsActive = isActive );
    }
    
     public static Order createOrder(String accountId, String priceBookId, String status, Date effectiveDate, String orderRecordTypeId, String billingDayOfMonth )
    {
         return new Order( AccountId = accountId , Pricebook2Id =  priceBookId , Status = status , EffectiveDate = effectiveDate, RecordTypeId = orderRecordTypeId ,blng__BillingDayOfMonth__c = billingDayOfMonth);
    }
    
    public static blng__BillingRule__c createBillingRule(String name, String initialBillingTrigger, String partialPeriodTreatment, String periodTreatmentForBTDO,String generateInvoices )
    {
        return new blng__BillingRule__c(Name = name, blng__InitialBillingTrigger__c = initialBillingTrigger , blng__PartialPeriodTreatment__c = partialPeriodTreatment, 
                                        blng__PeriodTreatmentForBTDO__c = periodTreatmentForBTDO, blng__GenerateInvoices__c = generateInvoices );
    }
    
    public static blng__RevenueRecognitionRule__c createRevenueRecognitionRule(String name , String createRevenueSchedule)
    {
        return new blng__RevenueRecognitionRule__c(Name = name , blng__CreateRevenueSchedule__c = createRevenueSchedule);
    }
    
    public static OrderItem createOrderItem(String pricebookEntryId, Integer quantity, Decimal unitPrice, String orderId, String Description, String taxeRule, String taxTreatement, 
                                            String taxCountry, String chargeType, String billingFrequency, String billingRule, String revenueRecognitionRule, String billingAccount)
    {
        return new OrderItem (PricebookEntryId = pricebookEntryId , Quantity = quantity, UnitPrice = unitPrice, OrderId = orderId , Description = Description, blng__BillingAccount__c = billingAccount,
                               blng__TaxRule__c = taxeRule , blng__TaxTreatment__c = taxTreatement , blng__TaxCountry__c = taxCountry, SBQQ__ChargeType__c = chargeType, 
                               SBQQ__BillingFrequency__c = billingFrequency,SBQQ__Activated__c = true, blng__BillingRule__c = billingRule, blng__RevenueRecognitionRule__c = revenueRecognitionRule ); 
        
    }
    
    
}
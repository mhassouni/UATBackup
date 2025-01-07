@isTest
public class OpportunityWarningHeader_TEST {
    @isTest
    private static void OpportunityWarningHeaderTest(){
        /////////////////////////////////////////////////////////////
        Bypass__c bypassSetting=Bypass__c.getInstance(UserInfo.getUserId());
        if (bypassSetting==null){
            bypassSetting=new Bypass__c();
            bypassSetting.OldBypassTriggersValidationRules__c = 'false:';
        }
        else{
            if(bypassSetting.BypassValidationRules__c != true)
            {
                bypassSetting.OldBypassTriggersValidationRules__c = bypassSetting.BypassValidationRules__c+':'+bypassSetting.BypassTriggers__c;
            }
        }
       
        bypassSetting.BypassValidationRules__c = true;
        upsert bypassSetting;
        //////////////////////////////
        Account Acc = new Account();
        Acc.CotationPF__c=4;
        Acc.Name='Test';
        Acc.ListeNoire__c =false;
        Acc.TECHDateListeNoire__c =null;
        Acc.Statut__c='Validé';
        Acc.recordtypeId=Label.CPT_RecordTypeId_CompteClient;
        insert Acc;
        Contact Cont = new Contact();
        Cont.AccountId=Acc.Id;
        Cont.LastName='Test';
        insert Cont;
        Opportunity OPP = new Opportunity();
        OPP.AccountId=Acc.Id;
        OPP.StageName='1 - Opportunité créée';
        OPP.Name='Opp Test'; 
        OPP.CloseDate=date.today();
        OPP.Probabilite_signature__c= '50% (Probable)';
        OPP.DateClotureEffective__c = system.today();
        OPP.DNP_Statut__c='Approuvée';
		insert OPP;
       
        Opportunity OPP2 = new Opportunity();
        OPP2.AccountId=Acc.Id;
        OPP2.StageName='1 - Opportunité créée';
        OPP2.Name='Opp Test2'; 
        OPP2.CloseDate=date.today();
        OPP2.Probabilite_signature__c= '50% (Probable)';
        OPP2.DateClotureEffective__c = system.today();
        OPP2.DNP_Statut__c='Approuvée';
		insert OPP2;
        //////////////////////////////////////
        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(OPP);
        OpportunityWarningHeader contr = new OpportunityWarningHeader(sc);
       // String param = ApexPages.currentPage().getParameters().get('DisplayWarning');
        // system.assertEquals('false', param);
        OPP.Sans_Concurrent__c=true;
        OPP.DateSignatureContrat__c=system.today();
        OPP.DateClotureEffective__c=system.today();
        OPP.StageName='6 - Contrat Signé';
        String OppId = OPP.Id;
        update OPP;
        OpportunityWarningHeader.IsDisplayWarning(OPP.Id);
        
        OPP2.Sans_Concurrent__c=true;
        OPP2.DateSignatureContrat__c=system.today();
        OPP2.StageName='4 - Proposition remise';
        update OPP2;
        OpportunityWarningHeader.IsDisplayWarning(OPP2.Id);
		Acc.CotationPF__c=9;  
        update Acc;
        OPP2.StageName='5 - Gagnée';
        OpportunityWarningHeader.IsDisplayWarning(OPP2.Id);
        OpportunityWarningHeader.IsDisplayWarning(OPP.Id);
        Test.stopTest();
    }
    
}
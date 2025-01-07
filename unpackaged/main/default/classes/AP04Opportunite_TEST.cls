@istest
public class AP04Opportunite_TEST 
{
     public static testMethod void AP04Opportunite_t() 
    {
    
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyBypass.BypassTriggers__c = 'AP01Opportunite';//validation du  compte ayant au mois 1 contact..
        insert MyBypass;
        account acc= Utils_TestMethods.createAccount('4563gddfh',null,null  ,Label.CPT_RecordTypeId_CompteClient	);
        insert acc;
        
        opportunity opp= Utils_TestMethods.createOpportunity('add',label.OPP_StageName_Gagnee,Date.today(),acc);
        opp.accountid=acc.id;
        opp.TypeOpportunite__c='NCT';
        opp.Quantite__c=6;
        opp.CodePF__c='vm';
        //opp.SousCategorie__c='V11M';
        opp.recordtypeid=label.OPP_RecordType_Vehicule_DRAFT;
        
        opportunity opp1= Utils_TestMethods.createOpportunity('add',label.OPP_StageName_Gagnee,Date.today(),acc);
        opp1.accountid=acc.id;
        opp1.TypeOpportunite__c='NCT';
        opp1.Quantite__c=6;
       // opp.CodePF__c='vm';
        opp1.SousCategorie__c='V11M';  
        opp1.recordtypeid=label.OPP_RecordType_Vehicule_DRAFT; 
      
        opportunity opp2= Utils_TestMethods.createOpportunity('add',label.OPP_StageName_Gagnee,Date.today(),acc);
        opp2.accountid=acc.id;
       // opp1.TypeOpportunite__c='NCT';
        opp2.Quantite__c=6;
       // opp.CodePF__c='vm';
        opp2.SousCategorie__c='V11M'; 
        opp2.recordtypeid=label.OPP_RecordType_Vehicule_DRAFT;   
             
        opportunity opp3= Utils_TestMethods.createOpportunity('add',label.OPP_StageName_Gagnee,Date.today(),acc);
        opp3.accountid=acc.id;
        opp3.TypeOpportunite__c='NCT';
        opp3.Quantite__c=6;
       // opp.CodePF__c='vm';
        opp3.SousCategorie__c='V11M';  
        opp3.recordtypeid=label.OPP_RecordType_Vehicule_DRAFT; 
      
        insert new  list<Opportunity> {opp,opp1,opp2,opp3};     
        map<string,Opportunity> ResultsMap = new map<string,Opportunity>([SELECT Name FROM Opportunity WHERE Id in (:opp.Id,:opp1.Id,:opp2.Id,:opp3.Id)]);
            
        system.assertequals(ResultsMap.get(opp.Id).Name,'NCT_6_vm_GDDFH');
        system.assertequals(ResultsMap.get(opp1.Id).Name,'NCT_6_V11M_GDDFH');
        system.assertequals(ResultsMap.get(opp2.Id).name,'add');
        system.assertequals(ResultsMap.get(opp3.Id).name,'NCT_6_V11M_GDDFH');
          
        opp1.TypeOpportunite__c='RNV';
        update(opp1);
        opportunity test5= [select name from opportunity where id=:opp1.id];
        system.assertequals(test5.name,'RNV_6_V11M_GDDFH');
       
    
    }
}
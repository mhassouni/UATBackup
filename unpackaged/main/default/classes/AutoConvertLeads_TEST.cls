@isTest 
      public class AutoConvertLeads_TEST{
      
          static testMethod void createnewlead() {
              User userToCreate = [Select id from user where Name='OP_TECH' AND IsActive=TRUE Limit 1];
              system.debug('userToCreate=='+userToCreate);
              Test.startTest(); 
                 
              Lead leadToCreate =new Lead();
              
              leadToCreate.ownerid= userToCreate.id;
              leadToCreate.LastName ='Gupta';
              leadToCreate.Company='Salesforce';
              leadToCreate.LeadSource='Employee Referral';
              leadToCreate.Rating='';
              leadToCreate.Status='';
              leadToCreate.Email = 'test@petitforestier.fr';
              insert leadToCreate; 
              
              Account acc = new Account();
              acc.Name = 'Salesforce';
              insert acc;
              
              Contact cont = new Contact();
              cont.LastName = 'Gupta';
              cont.AccountId = acc.Id;
              insert cont;
              
              system.debug('leadToCreate=='+leadToCreate);
              AutoConvertLeads.LeadToConvert ltc = new AutoConvertLeads.LeadToConvert();
              ltc.accountID = acc.Id;
              ltc.contactID = cont.Id;
              ltc.leadID = leadToCreate.Id;
              
              List<AutoConvertLeads.LeadToConvert> listLeadToConvert= New List<AutoConvertLeads.LeadToConvert>();
              listLeadToConvert.add(ltc);
              AutoConvertLeads.assignLeads(listLeadToConvert);
              
              Test.stopTest();
   }
}
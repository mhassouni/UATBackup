//Batch Nocturne
//Permet de marquer les flags suivants:
//Comptes Sans activités en cours
//Comptes Sans activités terminées

global class Batch_Flags_Acc implements Database.Batchable<sObject>{

    //start
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        //Bypass Validation Rules on Running User////////////////////////////
        Bypass__c bypassSetting=Bypass__c.getInstance(UserInfo.getUserId());
        if (bypassSetting==null){
            bypassSetting=new Bypass__c();
            bypassSetting.OldBypassTriggersValidationRules__c = 'false:';
        }
        else{
            if(bypassSetting.BypassTriggers__c != 'Batch_Flags_Acc' || bypassSetting.BypassValidationRules__c != true)
            {
                bypassSetting.OldBypassTriggersValidationRules__c = bypassSetting.BypassValidationRules__c+':'+bypassSetting.BypassTriggers__c;
            }
        }
        bypassSetting.BypassTriggers__c = 'Batch_Flags_Acc';
        bypassSetting.BypassValidationRules__c = true;
        upsert bypassSetting;
        
        
    	return database.getQueryLocator([SELECT Id, (SELECT Id FROM OpenActivities),(SELECT Id FROM ActivityHistories)FROM Account where Statut__c IN ('Validé','Validé CM')]);
       
  
	}
    //execute
    global void execute(database.BatchableContext BC,List<Account> scope)
    {
        System.Debug('>>>> Batch_Flags Start execute <<<<');
          
        //////////////////////////////
        //Execution
       ///////////////////////////////
       
        
//treatement of Account activities
////
        for(Account Acc: scope)
        { 
            //Opportunités:Activités en cours
            if(Acc.OpenActivities.size()==0)
            {
                Acc.Sans_Activites_En_Cours__c =true;
            }
            else
            {
				Acc.Sans_Activites_En_Cours__c =false;                
            }
            //opportunités:Activités terminées
            if(Acc.ActivityHistories.size()==0)
            {
                Acc.Sans_Activites_Terminees__c=true;
            }
            else
            {
                 Acc.Sans_Activites_Terminees__c=false;
            }
        }

       
                
 	    //////////////////////////
        //Updates
       ///////////////////////////////

         try{
 		update scope;
        }catch(exception e){System.debug(e);}
       
		 
       
    }

	//finish 
	global void finish(Database.BatchableContext BC){
         Bypass__c bypassSetting=Bypass__c.getInstance(UserInfo.getUserId());
            if (bypassSetting!=null && bypassSetting.OldBypassTriggersValidationRules__c!=null){
                bypassSetting.BypassTriggers__c = bypassSetting.OldBypassTriggersValidationRules__c.split(':')[1];
                if(bypassSetting.BypassTriggers__c=='null')
                {
                    bypassSetting.BypassTriggers__c = null;
                }
                bypassSetting.BypassValidationRules__c = boolean.valueof(bypassSetting.OldBypassTriggersValidationRules__c.split(':')[0]);
                bypassSetting.OldBypassTriggersValidationRules__c=null;
                upsert bypassSetting;
            }
         System.Debug('>>>> Batch_Flags End execute <<<<');
    }






















}
//Batch Nocturne
//Permet de marquer les flags suivants:
//Opportunités Sans Activités en cours
//Opportunités Sans Activités Terminées



global class Batch_Flags_Opp implements Database.Batchable<sObject>{
    //Lists finals
   
    
    List<Opportunity> Opp_S_Act_Encours = new List<Opportunity>();//Opportunités sans activités en cours
    List<Opportunity> Opp_S_Act_Terminees = new List<Opportunity>();//Opportunités sans activités terminées
    //List<Opportunity> Opp_S_Concurrent =  new List<Opportunity>();//Opportunités sans concurrent
    //List<Opportunity> Opp_A_Concurrent =  new List<Opportunity>();//Opportunités avec concurrent
    
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
            if(bypassSetting.BypassTriggers__c != 'Batch_Flags_Opp' || bypassSetting.BypassValidationRules__c != true)
            {
                bypassSetting.OldBypassTriggersValidationRules__c = bypassSetting.BypassValidationRules__c+':'+bypassSetting.BypassTriggers__c;
            }
        }
        bypassSetting.BypassTriggers__c = 'Batch_Flags_Opp';
        bypassSetting.BypassValidationRules__c = true;
        upsert bypassSetting;
        
        //////////////////////////////
        //Queries
       ///////////////////////////////
        //Opp_S_Concurrent = [SELECT ID FROM opportunity WHERE ID NOT IN(SELECT Opportunite__c FROM ActeurOpportunite__c where Role__c='Concurrent')];
        //Opp_A_Concurrent = [SELECT ID FROM opportunity WHERE ID IN(SELECT Opportunite__c FROM ActeurOpportunite__c where Role__c='Concurrent')];
        
        return database.getQueryLocator([SELECT Id, (SELECT Id FROM OpenActivities),(SELECT Id FROM ActivityHistories)FROM Opportunity]);
       
  
    }
    //execute
    global void execute(database.BatchableContext BC,List<Opportunity> scope)
    {
        System.Debug('>>>> Batch_Flags Start execute <<<<');
          
        //////////////////////////////
        //Execution
       ///////////////////////////////
       
        
//treatement of Opportunities activities
////
        for(Opportunity Opp: scope)
        { 
            //Opportunités:Activités en cours
            if(Opp.OpenActivities.size()==0)
            {
                Opp.Sans_Activites_En_Cours__c =true;
            }
            else
            {
                Opp.Sans_Activites_En_Cours__c =false;                
            }
            //opportunités:Activités terminées
            if(Opp.ActivityHistories.size()==0)
            {
                Opp.Sans_Activites_Terminees__c=true;
            }
            else
            {
                 Opp.Sans_Activites_Terminees__c=false;
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
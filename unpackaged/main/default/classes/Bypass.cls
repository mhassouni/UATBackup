public class Bypass{
    
    public static boolean canTrigger(string triggerClassName){
        
        if(String.isBlank(triggerClassName)){
            return true;
        }
        
        Bypass__c byPassOrg = Bypass__c.getOrgDefaults();
        if(byPassOrg!=null){
            
            if(byPassOrg.BypassAllTriggers__c){
                return false;
            }
            
            else if(!String.isBlank(byPassOrg.BypassTriggers__c) && byPassOrg.BypassTriggers__c.contains(triggerClassName)){
                return false;
            }
        }
        
        ByPass__c byPass = ByPass__c.getInstance(); // current user
        if(byPass != null){
            if(byPass.BypassAllTriggers__c)
                return false;
            else if(!String.isBlank(byPass.BypassTriggers__c) && byPass.BypassTriggers__c.contains(triggerClassName))
                return false;
        }
        
        return true;
    }
}
/**
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Bypass_TEST {

    static testMethod void BypassTest() {
        
        Bypass.canTrigger('');
        
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        insert MyBypass;
        Bypass.canTrigger('AP01Compte');
        
        MyBypass.BypassAllTriggers__c=TRUE;
        update MyBypass;
        Bypass.canTrigger('AP01Compte');
        
        MyBypass.BypassAllTriggers__c=FALSE;
        MyBypass.BypassTriggers__c = 'AP01Compte';
        update MyBypass;
        Bypass.canTrigger('AP01Compte');
        
        
        MyBypass.setupOwnerId = UserInfo.getOrganizationId();        
        MyBypass.BypassAllTriggers__c=TRUE;
        update MyBypass;
        Bypass.canTrigger('AP01Compte');
        
        MyBypass.BypassAllTriggers__c=FALSE;
        MyBypass.BypassTriggers__c = 'AP01Compte';
        update MyBypass;
        Bypass.canTrigger('AP01Compte');
        
        
    }
}
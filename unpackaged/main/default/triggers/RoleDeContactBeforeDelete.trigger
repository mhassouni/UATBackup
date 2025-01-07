trigger RoleDeContactBeforeDelete on RoleContact__c (before delete) {
	
	if(Bypass.canTrigger('AP01RoleDeContact'))
	{
		AP01RoleDeContact.PreventDeletion(trigger.old);
	}
}
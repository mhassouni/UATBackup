public class AP01RoleDeContact {
	
	public static void PreventDeletion(list<RoleContact__c> roles)
	{
		set<string> ParentOppIDs = new set<string>();
		for(RoleContact__c rc : roles)
		{
			ParentOppIDs.add(rc.Opportunite__c);
		}
		
		list<AggregateResult> ChildrenAgg = [	SELECT COUNT(CreatedDate) c, OpportuniteParent__c
												FROM Opportunity
												WHERE OpportuniteParent__c in: ParentOppIDs
													AND (NOT StageName =: Label.OPP_StageName_OpportuniteCreee)
													AND TECHNombreDeRoles__c <= 0
													AND OpportuniteParent__r.TECHNombreDeRoles__c = 1
												GROUP BY OpportuniteParent__c];
											
		map<string,integer> ParentNoContactChildrenMap = new map<string,integer>();
		for(AggregateResult ar : ChildrenAgg)
		{
			ParentNoContactChildrenMap.put(string.valueof(ar.get('OpportuniteParent__c')),integer.valueof(ar.get('c')));
		}
										
		for(RoleContact__c rc : roles)
		{
			if(ParentNoContactChildrenMap.get(rc.Opportunite__c)!=null)
			{
				rc.addError(Label.OPP_ErrorMessage_CantDeleteRole);
			}
		}
		
	}
    
}
trigger RelationAfterUpdate on Relation__c (after update) {

	/* CON-RG-011: "Si un contact A est ajouté au réseau d’un contact B, le contact B est automatiquement ajouté au réseau du contact A. 
	* 				Le type de la relation AB reste le même que celui de la relation BA, sauf si le type est « Client » ou « Fournisseur »:
	* 				- « Client » (AB) devient « Fournisseur » (BA)
	* 				- « Fournisseur » (AB) devient « Client »  (BA)"
	*/
	if(Bypass.canTrigger('AP01Relation'))
	{
		List<Relation__c> OldRelations = new List<Relation__c>();
		List<Relation__c> NewRelations = new List<Relation__c>();
		List<Relation__c> UpTypeRelations = new List<Relation__c>();
		
		for (Relation__c r : trigger.new)
		{
			if( r.ContactRelie__c != Trigger.oldMap.get(r.Id).ContactRelie__c
				|| r.ContactPrincipal__c != Trigger.oldMap.get(r.Id).ContactPrincipal__c)
    		{
    			OldRelations.Add(Trigger.oldMap.get(r.Id));
    			NewRelations.Add(r);
    		}
    		else if (r.TypeRelation__c != Trigger.oldMap.get(r.Id).TypeRelation__c) 
			{
				UpTypeRelations.add(r);
			}
		}
		
		if (UpTypeRelations.size()>0)
		{
			AP01Relation.UpdateRelations(UpTypeRelations);
		}
		
		if (OldRelations.size()>0)
    	{
    		AP01Relation.DeleteOldRelations(OldRelations);
    	}
    	
    	if (NewRelations.size()>0)
    	{
			AP01Relation.InsertNewRelations(NewRelations);
    	}
	}
	
}
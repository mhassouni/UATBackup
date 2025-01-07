/*
* CON-RG-011: "Si un contact A est ajouté au réseau d’un contact B, le contact B est automatiquement ajouté au réseau du contact A. 
	* 				Le type de la relation AB reste le même que celui de la relation BA, sauf si le type est « Client » ou « Fournisseur »:
	* 				- « Client » (AB) devient « Fournisseur » (BA)
	* 				- « Fournisseur » (AB) devient « Client »  (BA)"
* @Author Ali Naji
* @TestClass AP01Relation_TEST
* @CodeCoverage 95%
*/
public class AP01Relation {

	public static void DeleteOldRelations(List<Relation__c> relations)
	{
		
		List<Relation__c> OldRelations = new List<Relation__c>();
		
		Set<String> OneTwoCombination = new Set<String>();
		Set<String> FirstContactIDs = new Set<String>();
		Set<String> SecondContactIDs = new Set<String>();
		
		for (Relation__c r : relations)
		{
			OneTwoCombination.Add(string.valueof(r.ContactPrincipal__c)+string.valueof(r.ContactRelie__c) + string.valueof(r.TypeRelation__c));
			FirstContactIDs.Add(r.ContactPrincipal__c);
			SecondContactIDs.Add(r.ContactRelie__c);
		}
		List<Relation__c> ExistingRelevantRelations = [	SELECT ContactPrincipal__c, ContactRelie__c, TypeRelation__c
														FROM Relation__c
														WHERE ContactPrincipal__c in: SecondContactIDs
															AND ContactRelie__c in: FirstContactIDs];
		
		for (Relation__c r : ExistingRelevantRelations)
		{
			string RelationType = r.TypeRelation__c;
			if (r.TypeRelation__c==Label.REL_TypeRelation_Client)
			{
				RelationType = Label.REL_TypeRelation_Fournisseur;
			}
			else if (r.TypeRelation__c==Label.REL_TypeRelation_Fournisseur)
			{
				RelationType = Label.REL_TypeRelation_Client;
			}
			if (OneTwoCombination.contains(string.valueof(r.ContactRelie__c)+string.valueof(r.ContactPrincipal__c)+RelationType))
			{
				OldRelations.Add(r);
			}
		}
		
		if (OldRelations.size()>0)
		{
			delete OldRelations;
		}
		
	}

	public static void UpdateRelations(List<Relation__c> relations)
	{
		
		Set<String> FirstContactIDs = new Set<String>();
		Set<String> SecondContactIDs = new Set<String>();
		Map<String,String> comingCombinations = new Map<String,String>();
		
		for (Relation__c r : relations)
		{
			comingCombinations.put(r.ContactPrincipal__c+':'+r.ContactRelie__c, r.TypeRelation__c);
			FirstContactIDs.Add(r.ContactPrincipal__c);
			SecondContactIDs.Add(r.ContactRelie__c);
		}
		List<Relation__c> ExistingRelevantRelations = [	SELECT ContactPrincipal__c, ContactRelie__c, TypeRelation__c
														FROM Relation__c
														WHERE ContactPrincipal__c in: SecondContactIDs
															AND ContactRelie__c in: FirstContactIDs];
															
		List<Relation__c> ToUpdate = new List<Relation__c>();
		for (Relation__c r : ExistingRelevantRelations)
		{
			if (comingCombinations.containskey(string.valueof(r.ContactRelie__c)+':'+string.valueof(r.ContactPrincipal__c)))
			{
				string RelationType = comingCombinations.get(r.ContactRelie__c+':'+r.ContactPrincipal__c);
				if (RelationType==Label.REL_TypeRelation_Client)
				{
					RelationType = Label.REL_TypeRelation_Fournisseur;
				}
				else if (RelationType==Label.REL_TypeRelation_Fournisseur)
				{
					RelationType = Label.REL_TypeRelation_Client;
				}
					
				if(r.TypeRelation__c != RelationType)
				{
					r.TypeRelation__c = RelationType;
					ToUpdate.add(r);
				}
			}
		}
		if (ToUpdate.size()>0)
		{
			update ToUpdate;
		}
	}

	public static void InsertNewRelations(List<Relation__c> relations)
	{
				
		Set<String> FirstContactIDs = new Set<String>();
		Set<String> SecondContactIDs = new Set<String>();
		for (Relation__c r : relations)
		{
			FirstContactIDs.Add(r.ContactPrincipal__c);
			SecondContactIDs.Add(r.ContactRelie__c);
		}
		List<Relation__c> ExistingRelevantRelations = [	SELECT ContactPrincipal__c, ContactRelie__c, TypeRelation__c
														FROM Relation__c
														WHERE ContactPrincipal__c in: SecondContactIDs
															AND ContactRelie__c in: FirstContactIDs];
															
		Set<String> OneTwoCombination = new Set<String>();
		for (Relation__c r : ExistingRelevantRelations)
		{
			OneTwoCombination.Add(string.valueof(r.ContactPrincipal__c)+string.valueof(r.ContactRelie__c));
		}
		
		List<Relation__c> NewRelations = new List<Relation__c>();
		for (Relation__c r : relations)
		{
			if (!OneTwoCombination.contains(string.valueof(r.ContactRelie__c)+string.valueof(r.ContactPrincipal__c)))
			{
				string RelationType = r.TypeRelation__c;
				if (r.TypeRelation__c==Label.REL_TypeRelation_Client)
				{
					RelationType = Label.REL_TypeRelation_Fournisseur;
				}
				else if (r.TypeRelation__c==Label.REL_TypeRelation_Fournisseur)
				{
					RelationType = Label.REL_TypeRelation_Client;
				}
				NewRelations.Add(new Relation__c(ContactPrincipal__c=r.ContactRelie__c, ContactRelie__c=r.ContactPrincipal__c, TypeRelation__c=RelationType));
			}
		}
		if (NewRelations.size()>0)
		{
			insert NewRelations;
		}
		
	}

}
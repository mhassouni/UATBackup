/*
* CON-RG-011: "Si un contact A est ajouté au réseau d’un contact B, le contact B est automatiquement ajouté au réseau du contact A. 
	* 				Le type de la relation AB reste le même que celui de la relation BA, sauf si le type est « Client » ou « Fournisseur »:
	* 				- « Client » (AB) devient « Fournisseur » (BA)
	* 				- « Fournisseur » (AB) devient « Client »  (BA)"
* @Author Ali Naji
* @TestClass for AP01Relation
*/
@isTest
    private class AP01Relation_TEST {

    static testMethod void MirrorRelationTest() {

		Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
		MyBypass.BypassValidationRules__c = true;
		insert MyBypass;
		
		Account Account1 = Utils_TestMethods.createAccount('Account1',null,null,Label.CPT_RecordTypeId_CompteClient	);
		insert Account1;
		
		Contact Contact1 = Utils_TestMethods.createContact('Contact1',Account1.Id);
		Contact Contact2 = Utils_TestMethods.createContact('Contact2',Account1.Id);
		Contact Contact3 = Utils_TestMethods.createContact('Contact3',Account1.Id);
        Contact Contact4 = Utils_TestMethods.createContact('Contact4',Account1.Id);
		insert new List<Contact>{Contact1,Contact2,Contact3,Contact4};
		
		Relation__c Relation1 = Utils_TestMethods.createRelation(Contact1.Id,Contact2.Id,Label.REL_TypeRelation_Ami);
		insert Relation1;
		
		Relation__c Relation2 = [	SELECT TypeRelation__c 
									FROM Relation__c
									WHERE ContactPrincipal__c=:Contact2.Id
										AND ContactRelie__c=:Contact1.Id LIMIT 1];
		System.AssertEquals(Relation2.TypeRelation__c, Label.REL_TypeRelation_Ami);
		
		Relation1.ContactRelie__c = Contact3.Id;
		Relation1.TypeRelation__c = Label.REL_TypeRelation_Client;
		update Relation1;
		
		integer Relation2Count = [	SELECT COUNT()
									FROM Relation__c
									WHERE Id=:Relation2.Id];
		Relation__c Relation3 = [	SELECT TypeRelation__c
									FROM Relation__c
									WHERE ContactPrincipal__c=:Contact3.Id
										AND ContactRelie__c=:Contact1.Id LIMIT 1];
		System.AssertEquals(Relation2Count,0);
		System.AssertEquals(Relation3.TypeRelation__c,Label.REL_TypeRelation_Fournisseur);
		
		Relation1.TypeRelation__c = Label.REL_TypeRelation_Fournisseur;
		update Relation1;
		
		Relation3 = [	SELECT TypeRelation__c
						FROM Relation__c
						WHERE ContactPrincipal__c=:Contact3.Id
							AND ContactRelie__c=:Contact1.Id LIMIT 1];

		System.AssertEquals(Relation3.TypeRelation__c,Label.REL_TypeRelation_Client);
		
		delete Relation1;
		
		integer Relation3Count = [	SELECT COUNT()
									FROM Relation__c
									WHERE Id=:Relation3.Id];
		System.AssertEquals(Relation3Count,0);
        
        
    }
}
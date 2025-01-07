trigger RelationAfterInsert on Relation__c (after insert) {

	/* CON-RG-011: "Si un contact A est ajouté au réseau d’un contact B, le contact B est automatiquement ajouté au réseau du contact A. 
	* 				Le type de la relation AB reste le même que celui de la relation BA, sauf si le type est « Client » ou « Fournisseur »:
	* 				- « Client » (AB) devient « Fournisseur » (BA)
	* 				- « Fournisseur » (AB) devient « Client »  (BA)"
	*/
	if(Bypass.canTrigger('AP01Relation'))
	{
		AP01Relation.InsertNewRelations(trigger.new);
	}

}
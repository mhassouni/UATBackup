trigger OpportuniteBeforeUpdate on Opportunity (before update) {

    /*ACTION PRELIMINAIRES*/
    set<Id> setAccIds=new set<Id>();
    for(Opportunity o : trigger.new){
        setAccIds.add(o.AccountId);
    }
    
    map<Id, Account> mapAccs=new map<Id, Account>([select Id, PaysExploitation__c
                                                   from Account
                                                   where Id in :setAccIds]);
    
    for (Opportunity o : trigger.new){
        //remplir le pays d'exploitation du compte de l'opp dans le champ liste de sélection "TECH Pays Compte" (pour l'utiliser dans les filtres de recherche)
        if(mapAccs.get(o.AccountId)!=null){
            o.TECHPaysCompte__c=mapAccs.get(o.AccountId).PaysExploitation__c;
        }
    }


    
    if(Bypass.canTrigger('AP04Opportunite')){
        List<Opportunity> ToInsert = new List<Opportunity>();
        List<Opportunity> ToInsert_container = new List<Opportunity>();
        List<Opportunity> ToInsert_Reways = new List<Opportunity>();
         List<Opportunity> ToInsert_SAPCPQ = new List<Opportunity>();
        for (Opportunity o : trigger.new)
        {
           if (
               // NOM OPP - Véhicules 
               (o.Quantite__c!=trigger.oldMap.get(o.Id).Quantite__c
           		|| o.TypeOpportunite__c != trigger.oldMap.get(o.Id).TypeOpportunite__c
           		|| o.CodePF__c != trigger.oldMap.get(o.Id).CodePF__c
          		|| o.SousCategorie__c != trigger.oldMap.get(o.Id).SousCategorie__c
           		|| o.accountid !=trigger.oldMap.get(o.Id).accountid
           		&&
           		(  o.RecordTypeId == Label.OPP_RecordType_Vehicule_DRAFT|| o.RecordTypeId == Label.OPP_RecordType_Vehicule_ENCOURS) 
               ) 
               || (o.RecordTypeId == Label.OPP_RecordType_Meuble || o.RecordTypeId == Label.OPP_RecordType_Meuble_Fermee))
           {
              ToInsert.add(o);
           }
                           // NOM OPP - Containers 
             if (o.TypeOpportunite__c != trigger.oldMap.get(o.Id).TypeOpportunite__c || o.Type_Location__c != trigger.oldMap.get(o.Id).Type_Location__c
                     &&
                     (o.RecordTypeId == Label.OPP_RecordType_Container_DRAFT ||o.RecordTypeId == Label.OPP_Recordtype_Container_EnCours))
            {
                ToInsert_container.add(o);
            }
                           // NOM OPP - Reways 
            if( (o.Quantite__c!=trigger.oldMap.get(o.Id).Quantite__c || o.SousFamille__c !=  trigger.oldMap.get(o.Id).SousFamille__c)  && (o.PaysRegionPF__c== 'Reways'))
            {
                ToInsert_Reways.add(o);
            }
            if( (o.recordtypeId == Label.OPP_Recordtypeid_CPQ_LD || o.recordtypeId == Label.OPP_Recordtypeid_CPQ_CDMD) && o.TypeContrat__c <> null)
            {
                ToInsert_SAPCPQ.add(o);
            }
        }
        if (ToInsert.size()>0)
        {
            AP04Opportunite.GenerateOppName(ToInsert);
        }
        if(ToInsert_container.size()>0)
        {
          AP04Opportunite.GenerateOppName_Container(ToInsert_container);  
        }
        if(ToInsert_Reways.size()>0)
        {
            AP04Opportunite.GenerateOppName_Reways(ToInsert_Reways);
        }
      	if (ToInsert_SAPCPQ.size()>0)
        {
            AP04Opportunite.GenerateOppName_SAPCPQ(ToInsert_SAPCPQ);
        }
    }  

}
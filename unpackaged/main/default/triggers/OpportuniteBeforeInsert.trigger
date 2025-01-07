trigger OpportuniteBeforeInsert on Opportunity (before insert) {

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
    /**/
    

    
    if(Bypass.canTrigger('AP04Opportunite'))
    {
        list<Opportunity> ToInsert = new list<Opportunity>();
        list<Opportunity> ToInsert_container = new list<Opportunity>();
        list<Opportunity> ToInsert_Reways = new list<Opportunity>();
        list<Opportunity> ToInsert_SAPCPQ = new list<Opportunity>();
        for(Opportunity o : trigger.new)
        {
            if(o.RecordTypeId == Label.OPP_RecordType_Meuble || o.RecordTypeId == Label.OPP_RecordType_Vehicule_DRAFT )
            {
                ToInsert.add(o);
                Set<Id> accSetId = new Set<Id>();
                List<Account> accountListe=[select Id
                                                   from Account
                                                   where Id =:o.AccountId];
                for(Account acc : accountListe)
                {
                    accSetId.add(acc.Id);
                }
                AP09Compte.ProcessUpdateAccountGradeInformation(accSetId);
            }
            else if (o.RecordtypeId==Label.OPP_RecordType_Container_DRAFT || o.RecordTypeId == Label.OPP_Recordtype_Container_EnCours)
            {
              ToInsert_container.add(o);
                Set<Id> accSetId = new Set<Id>();
                List<Account> accountListe=[select Id
                                                   from Account
                                                   where Id =:o.AccountId];
                for(Account acc : accountListe)
                {
                    accSetId.add(acc.Id);
                }
                AP09Compte.ProcessUpdateAccountGradeInformation(accSetId);  
            }
            else if ((o.recordtypeId == Label.OPP_Recordtypeid_CPQ_LD || o.recordtypeId == Label.OPP_Recordtypeid_CPQ_CDMD) && o.TypeContrat__c<>null)
            {
                 ToInsert_SAPCPQ.add(o);

            }
            else if(o.PaysRegionPF__c == 'Reways')
            {
                ToInsert_Reways.add(o);
            }
            
            if(ToInsert.size()>0)
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
            if(ToInsert_SAPCPQ.size()>0)  
             
            {
                AP04Opportunite.GenerateOppName_SAPCPQ(ToInsert_SAPCPQ);
                                  
            }
        }
    }


}
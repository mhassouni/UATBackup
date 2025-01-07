public class BatchCountChildren implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([select Id from Account where recordtypeid=:Label.ACC_RecordTypeId_CompteNoeud ]);
    }
    
    public void execute(Database.BatchableContext context, List<Account> scope) {
        List<Account> accLst = new List<Account>();
            for (AggregateResult ar : [
                SELECT UltimateAccount__c a ,count(Id) c
                FROM Account
                WHERE UltimateAccount__c in :scope AND recordtypeid=:Label.ACC_RecordTypeId_CompteClient
                GROUP BY UltimateAccount__c
            ]) {
                accLst.add(new Account(
                    Id = (Id) ar.get('a'),
                    Ultimate_Nb_enfants__c = (Decimal) ar.get('c')
                ));
            }
        UPDATE accLst;
    }
    
    public void finish(Database.BatchableContext context) {
    }
}
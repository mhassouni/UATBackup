public class BatchCountEvents implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([select Id from Account order where recordtypeid=:Label.ACC_RecordTypeId_CompteClient	]);
    }
    
    public void execute(Database.BatchableContext context, List<Account> scope) {
        List<Account> accLst = new List<Account>();
            for (AggregateResult ar : [
                SELECT AccountId a, count(Id) c
                FROM Event
                WHERE AccountId in :scope AND This_Year__c=true AND Mode_de_communication__c<>'Tél'
                GROUP BY AccountId
            ]) {
                accLst.add(new Account(
                    Id = (Id) ar.get('a'),
                    Nb_RDV_effectues__c = (Decimal) ar.get('c')
                ));
            }
        UPDATE accLst;
    }
    
    public void finish(Database.BatchableContext context) {
    }
}
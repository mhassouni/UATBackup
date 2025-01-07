public class BatchCountContainers implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([select Id from Account order where recordtypeid=:Label.ACC_RecordTypeId_CompteSite	]);
    }
    
    public void execute(Database.BatchableContext context, List<Account> scope) {
        List<Account> accLst = new List<Account>();
            for (AggregateResult ar : [
                SELECT AccountId a, count(Id) c
                FROM Asset
                WHERE AccountId in :scope AND RecordtypeId=:Label.Parc_Container_RecordTypeId		
                GROUP BY AccountId
            ]) {
                accLst.add(new Account(
                    Id = (Id) ar.get('a'),
                    Nombre_de_Containers__c = (Decimal) ar.get('c')
                ));
            }
        UPDATE accLst;
    }
    
    public void finish(Database.BatchableContext context) {
    }
}
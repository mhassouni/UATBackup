public class AP09Compte_CalledBySchedule implements SCHD09Compte.IScheduleAccount{
    public void Execute(SchedulableContext sc){
        AP09Compte_BATCH batch1 = new AP09Compte_BATCH();
        ID batchprocessid = Database.executeBatch(batch1,1);
    }
}
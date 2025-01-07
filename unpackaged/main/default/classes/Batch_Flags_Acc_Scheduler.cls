global class Batch_Flags_Acc_Scheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    Batch_Flags_Acc b = new Batch_Flags_Acc(); 

      database.executebatch(b,50);
 
    }
}
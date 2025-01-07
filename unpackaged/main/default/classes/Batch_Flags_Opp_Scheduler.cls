global class Batch_Flags_Opp_Scheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    Batch_Flags_Opp b = new Batch_Flags_Opp(); 

      database.executebatch(b,100);
       
 
    }
}
global class Batch_Contract_Uplift_Scheduler implements Schedulable  {
    
    global void execute(SchedulableContext sc)
        
    {
        
        Batch_Contract_Uplift b = new Batch_Contract_Uplift(true); 
        
        database.executeBatch(b);
        
    }
}
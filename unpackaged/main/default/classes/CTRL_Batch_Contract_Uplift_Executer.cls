public class CTRL_Batch_Contract_Uplift_Executer {
    
    @auraEnabled
    public static void executeBatch(){
        Batch_Contract_Uplift b = new Batch_Contract_Uplift(true);
        Database.executeBatch(b);
    }

}
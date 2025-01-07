global class SCHD08Compte implements Schedulable{
    public static String CRON_EXP = Label.CPT_Batch_Time;
    
    public Interface IScheduleAccount{
        void execute(SchedulableContext sc);
    }
    
    global void execute(SchedulableContext sc){
        System.Debug('>>>> SCHD08Comptet Start AP08Compte_BATCH <<<<');
        
        Type targettype = Type.forName('AP08Compte_CalledBySchedule');
        
        if(targettype !=null){  
            IScheduleAccount  obj = (IScheduleAccount)targettype.NewInstance();  
            obj.execute(sc);
        } 
        
        System.Debug('>>>> SCHD08Compte End AP08Compte_BATCH <<<<');
    }
}
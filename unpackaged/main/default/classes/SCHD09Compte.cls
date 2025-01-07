global class SCHD09Compte implements Schedulable{
    
    public Interface IScheduleAccount{
        void execute(SchedulableContext sc);
    }
    
    global void execute(SchedulableContext sc){
        System.Debug('>>>> SCHD09Compte Start AP09Compte_BATCH <<<<');
        
        Type targettype = Type.forName('AP09Compte_CalledBySchedule');
        
        if(targettype !=null){  
            IScheduleAccount  obj = (IScheduleAccount)targettype.NewInstance();  
            obj.execute(sc);
            
            Datetime InFive = system.now().addMinutes(5);
             
            String second = string.valueOf(InFive.second());
            String minute = string.valueOf(InFive.minute());
            String hour = string.valueOf(InFive.hour());
            String day = string.valueOf(InFive.day());
            String month = string.valueOf(InFive.month());
            String year = string.valueOf(InFive.year());
            
            for(CronTrigger ct : [SELECT ID FROM CronTrigger WHERE State = 'Deleted'])
            {
                System.abortJob(ct.Id);
            }
            
            String strJobName = 'SCHD09Compte: ' + year + '-' + month + '-' + day + ' ' + hour+ ':' + minute+ ':' + second; //+ year + '-' + month + '-' + day + ' ' + hour+ ':' + minute+ ':' + second
            String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            system.debug('strSchedule: '+strSchedule);
            System.schedule(strJobName, strSchedule, new SCHD09Compte());
            
        } 
        
        System.Debug('>>>> SCHD09Compte End AP09Compte_BATCH <<<<');
    }
}
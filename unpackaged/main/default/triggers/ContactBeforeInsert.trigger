trigger ContactBeforeInsert on Contact (Before insert) {
     if(Bypass.canTrigger('AP02Contact'))
     {
     System.debug('##start trigger before insert maj');
         AP02Contact.MAJPrenomMajuscules(trigger.new);
     }                                   
}
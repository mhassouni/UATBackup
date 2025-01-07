public class CaseClass {
	public static void CaseEnAttente(String Id)
    {
            Case C = [SELECT requete_en_attente__c,Status,Agence_Intervenante__c,TECH_Notification_sent__c FROM Case WHERE id=:Id];
       
                C.requete_en_attente__c=false;
        		
    }
    
    public static void CaseNotificationSent(String Id)
    {
                    Case C = [SELECT requete_en_attente__c,Status,Agence_Intervenante__c,TECH_Notification_sent__c FROM Case WHERE id=:Id];
                    C.TECH_Notification_sent__c = false;
        			
    }
   

   
}
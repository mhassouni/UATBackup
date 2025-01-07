trigger CaseBeforeUpdate on Case (before UPDATE) {
 for(Case C : Trigger.New) {
    
        if(C.requete_en_attente__c == TRUE && C.Status != trigger.oldMap.get(C.Id).Status ){
			if(trigger.oldMap.get(C.Id).Status == Label.Case_Statut_Nouvelle || trigger.oldMap.get(C.Id).Status ==Label.Case_Statut_EnCours) {
                CaseClass.CaseEnAttente(C.Id);
            } 
        }
     //Si agence intervenante est modifiée
     	 if (C.Agence_Intervenante__c !=trigger.oldMap.get(C.Id).Agence_Intervenante__c  && C.TECH_Notification_sent__c==true)
        {
            CaseClass.CaseNotificationSent(C.Id);
        }
    }   
}
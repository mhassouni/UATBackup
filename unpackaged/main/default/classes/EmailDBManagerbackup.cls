public class EmailDBManagerbackup {
    public static String getFieldLabel(String objectApiName, String fieldApiName) {
    Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
    Schema.SObjectField field = objDescribe.fields.getMap().get(fieldApiName);
    if (field != null) {
        return field.getDescribe().getLabel();
    } else {
        return null; // Ou "fieldApiName" si vous voulez retourner le nom API par défaut
    }
}
    public static void sendModificationEmails(Map<Id, Set<String>> accountToModifiedFields, Map<Id, Account> oldMap, Map<Id, Account> newMap) {
        String headerStyle = ' style="background-color: green; color: white;"';
        // Trouver tous les SalesAreaData__c liés à ces comptes pour obtenir les e-mails des utilisateurs
        Set<Id> accountIds = accountToModifiedFields.keySet();
        Map<Id, Set<String>> accountToEmails = new Map<Id, Set<String>>();
        
        List<SalesAreaData__c> salesAreaDataList = [SELECT Account__c, TerritorialCommercial__c, ManagerCommercial__c FROM SalesAreaData__c WHERE Account__c IN :accountIds];
       
        for (SalesAreaData__c sad : salesAreaDataList) {
            if (!accountToEmails.containsKey(sad.Account__c)) {
                accountToEmails.put(sad.Account__c, new Set<String>());
            }
            if (sad.TerritorialCommercial__c != null) {
                accountToEmails.get(sad.Account__c).add(sad.TerritorialCommercial__c);
            }
            if (sad.ManagerCommercial__c != null) {
                accountToEmails.get(sad.Account__c).add(sad.ManagerCommercial__c);
            }
        }
        
        // Préparer et envoyer les e-mails
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for (Id accId : accountIds) {
            Set<String> emails = accountToEmails.get(accId);
            if (emails != null && !emails.isEmpty()) {
                Account Acc = newMap.get(accId);
                // Construction du tableau HTML
                String emailBody = system.Label.MonitoringDB_MailAutomatique; 
                emailBody+='<br/><br/>';
                emailBody +=system.Label.MonitoringDB_Message;
                emailBody +='<a href="' + Acc.TECHLienSF__c + '">' + Acc.Name + '</a><br/><br/>';
                emailBody += '<table border="1px" style="border-collapse:collapse; padding: 10px;"><tr><th' + headerStyle + '></th>';
                
               // Entêtes horizontales avec style et utilisation des libellés
                for (String fieldApiName : accountToModifiedFields.get(accId)) {
                    String fieldLabel = getFieldLabel('Account', fieldApiName); // 'Account' est à remplacer par votre objet si différent
                    emailBody += '<th' + headerStyle + '>' + (fieldLabel != null ? fieldLabel : fieldApiName) + '</th>';
                }
                emailBody += '</tr>';
                
                // Ligne des anciennes valeurs
                emailBody += '<tr><td ' + headerStyle + '>'+system.Label.MonitoringDB_Anciennevaleur+'</td>';
                for (String field : accountToModifiedFields.get(accId)) {
                    Account oldAcc = oldMap.get(accId);
                    emailBody += '<td>' + String.valueOf(oldAcc.get(field)) + '</td>';
                }
                emailBody += '</tr>';
                
                // Ligne des nouvelles valeurs
                emailBody += '<tr><td ' + headerStyle + '>'+system.Label.MonitoringDB_Nouvellevaleur+'</td>';
                for (String field : accountToModifiedFields.get(accId)) {
                    Account newAcc = newMap.get(accId);
                    emailBody += '<td>' + String.valueOf(newAcc.get(field)) + '</td>';
                }
                emailBody += '</tr></table>';
                emailBody+='<br/><br/>';
                emailBody+=System.Label.MonitoringDB_EquipeSF;
                
                // Envoyer l'email à chaque utilisateur
                for (String userEmail : emails) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSenderDisplayName('Greenforce DB Monitoring');
                   /* OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'no-reply@petitforestier.fr'];
					
					if ( owea.size() > 0 ) {
    				mail.setOrgWideEmailAddressId(owea.get(0).Id);
					}*/
                    mail.setToAddresses(new List<String>{userEmail});
                    mail.setSubject(System.Label.MonitoringDB_Titre +' '+Acc.Name);
                    mail.setHtmlBody(emailBody);
                    emailsToSend.add(mail);
                }
            }
        }
        
        // Vérifiez si la liste n'est pas vide avant d'envoyer pour éviter des erreurs
        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
}
public class EmailDBManager {
   public static void sendModificationEmails(Map<Id, Set<String>> accountToModifiedFields, Map<Id, Account> oldMap, Map<Id, Account> newMap) {
    
       // Trouver tous les SalesAreaData__c liés à ces comptes pour obtenir les e-mails et les langues des utilisateurs
    Set<Id> accountIds = accountToModifiedFields.keySet();
    Map<Id, Set<String>> accountToEmails = new Map<Id, Set<String>>();
    Map<String, String> emailToLanguage = new Map<String, String>(); // Nouveau mapping pour les langues

    List<SalesAreaData__c> salesAreaDataList = [SELECT Account__c, TerritorialCommercial__c, ManagerCommercial__c FROM SalesAreaData__c WHERE Account__c IN :accountIds];

    // Récupérer les langues associées à chaque email
    Map<Id, User> users = new Map<Id, User>([SELECT Id, Email, LanguageLocaleKey FROM User WHERE Id IN :getUserIdsFromSalesAreaData(salesAreaDataList)]);

    for (SalesAreaData__c sad : salesAreaDataList) {
        if (!accountToEmails.containsKey(sad.Account__c)) {
            accountToEmails.put(sad.Account__c, new Set<String>());
        }
        if (sad.TerritorialCommercial__c != null && users.containsKey(sad.TerritorialCommercial__c)) {
            accountToEmails.get(sad.Account__c).add(users.get(sad.TerritorialCommercial__c).Email);
            emailToLanguage.put(users.get(sad.TerritorialCommercial__c).Email, users.get(sad.TerritorialCommercial__c).LanguageLocaleKey);
        }
        if (sad.ManagerCommercial__c != null && users.containsKey(sad.ManagerCommercial__c)) {
            accountToEmails.get(sad.Account__c).add(users.get(sad.ManagerCommercial__c).Email);
            emailToLanguage.put(users.get(sad.ManagerCommercial__c).Email, users.get(sad.ManagerCommercial__c).LanguageLocaleKey);
        }
    }

    // Envoyer les e-mails en utilisant les langues récupérées
    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

    for (Id accId : accountIds) {
        Set<String> emails = accountToEmails.get(accId);
        if (emails != null && !emails.isEmpty()) {
            Account acc = newMap.get(accId);
            for (String userEmail : emails) {
                String userLanguage = emailToLanguage.get(userEmail);
                // Générer le corps de l'email pour cette langue spécifique
                String emailBody = generateEmailBody(acc, accountToModifiedFields.get(accId), oldMap,newMap, userLanguage);

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSenderDisplayName('Greenforce DB Monitoring');
                mail.setToAddresses(new List<String>{userEmail});
                String title = getTranslatedLabel(null, 'MonitoringDB_Titre', userLanguage);
                title+= ' '+acc.Name; 
                mail.setSubject(title); // Assurez-vous que le titre est également traduit
                mail.setHtmlBody(emailBody);
                emailsToSend.add(mail);
            }
        }
    }

    if (!emailsToSend.isEmpty()) {
        Messaging.sendEmail(emailsToSend);
    }
}



     public static String generateEmailBody(Account acc, Set<String> modifiedFields, Map<Id, Account> oldMap, Map<Id, Account> newMap, String userLanguage) {
        String headerStyle = ' style="background-color: green; color: white;"';
        // Using getFieldLabel to fetch custom labels with translations
        String emailBody = getTranslatedLabel(null, 'MonitoringDB_MailAutomatique', userLanguage);
        emailBody += '<br/><br/>';
        emailBody += getTranslatedLabel(null, 'MonitoringDB_Message', userLanguage);
        emailBody += '<a href="' + acc.TECHLienSF__c + '">' + acc.Name + '</a><br/><br/>';
        emailBody += '<table border="1px" style="border-collapse:collapse; padding: 10px;"><tr><th' + headerStyle + '></th>';

        // Headers with style and usage of labels for fields
        for (String fieldApiName : modifiedFields) {
            String fieldLabel = getFieldLabelTranslation('Account', fieldApiName, userLanguage); // Assuming 'Account' object, replace if different
            emailBody += '<th' + headerStyle + '>' + (fieldLabel != null ? fieldLabel : fieldApiName) + '</th>';
        }
        emailBody += '</tr>';

        // Line of old values
        emailBody += '<tr><td ' + headerStyle + '>' + getTranslatedLabel(null, 'MonitoringDB_Anciennevaleur', userLanguage) + '</td>';
        for (String field : modifiedFields) {
            Account oldAcc = oldMap.get(acc.Id);
            emailBody += '<td>' + String.valueOf(oldAcc.get(field)) + '</td>';
        }
        emailBody += '</tr>';

        // Line of new values
        emailBody += '<tr><td ' + headerStyle + '>' + getTranslatedLabel(null, 'MonitoringDB_Nouvellevaleur', userLanguage) + '</td>';
        for (String field : modifiedFields) {
            Account newAcc = newMap.get(acc.Id);
            emailBody += '<td>' + String.valueOf(newAcc.get(field)) + '</td>';
        }
        emailBody += '</tr></table>';
        emailBody += '<br/><br/>';
        emailBody += getTranslatedLabel(null, 'MonitoringDB_EquipeSF', userLanguage);

        return emailBody;
    }

private static Set<Id> getUserIdsFromSalesAreaData(List<SalesAreaData__c> salesAreaData) {
    Set<Id> userIds = new Set<Id>();
    for (SalesAreaData__c sad : salesAreaData) {
        if (sad.TerritorialCommercial__c != null) userIds.add(sad.TerritorialCommercial__c);
        if (sad.ManagerCommercial__c != null) userIds.add(sad.ManagerCommercial__c);
    }
    return userIds;
}
    
//Retourne la traduction d'un custom label s'il existe,sinon la valeur
public static String getTranslatedLabel(String namespace, String labelApiName, String languageLocaleKey) {
        // Check if the translation for the specified label and language exists
        if (System.Label.translationExists(namespace, labelApiName, languageLocaleKey)) {
            // Retrieve the translated label
            return System.Label.get(namespace, labelApiName, languageLocaleKey);
        } else {
            // If no translation exists, return the default label value
            return System.Label.get(namespace, labelApiName, 'fr');
        }
    
       
    
}
 
//Retourne la traduction du libellé d'un champ d'une langue 
  public static String getFieldLabelTranslation(String objectApiName, String fieldApiName, String languageLocaleKey) {
        // Récuperer la traduction correspodante au champ via custom labels
        String FormatedNameToLabel = 'MonitoringDB_'+fieldApiName;
      	FormatedNameToLabel = FormatedNameToLabel.replace('__c', '_c');
        String fieldLabel = getTranslatedLabel(null,FormatedNameToLabel , languageLocaleKey);
  if (fieldLabel != null) {
    return fieldLabel;
  } else {
      //Si aucune traduction,renvoi le libellé par défaut
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
        if (objectType != null) {
            Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
            // Retrieve the field from the described object
            Map<String, Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
            Schema.SObjectField field = fieldMap.get(fieldApiName);
            if (field != null) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                // Return the field label; Salesforce handles user language translation based on user settings
                return fieldDescribe.getLabel();
            } else {
                return 'Field not found.';
            }
        } else {
            return 'Object not found.';
        }
  }  }


}
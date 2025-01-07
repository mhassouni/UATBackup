/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_InterfaceResponseTriggerHandler {

    /**
     * Handler class that updates the record status coming from SAP
     */
    public with sharing class UpdateRecordStatusFromInterface implements Intf_Framework_Triggers.Handler {
    
        public void handle() {

            Map<String, String> responseClassMapping = new Map<String, String>();
            Map<String, List<Interface_Response__c>> messagesByHandlingClasses = new Map<String, List<Interface_Response__c>>();
            List<Interface_Response__c> interfacesNotTreatable = new List<Interface_Response__c>();

            for (Intf_Response_Handler__mdt intfResponseHandler : [SELECT Handling_Class__c, Interface_Name__c FROM Intf_Response_Handler__mdt]) {
                responseClassMapping.put(intfResponseHandler.Interface_Name__c, intfResponseHandler.Handling_Class__c);
            }

            for (Interface_Response__c message : (List<Interface_Response__c>)Trigger.new) {

                String handlingClass = responseClassMapping.get(message.Interface_Name__c);

                if (handlingClass != null) {
                    if (!messagesByHandlingClasses.containsKey(handlingClass)) {
                        messagesByHandlingClasses.put(handlingClass, new List<Interface_Response__c>());
                    }
                    List<Interface_Response__c> interfaceResponses = messagesByHandlingClasses.get(handlingClass);
                    interfaceResponses.add(message);

                } else {
                    interfacesNotTreatable.add(new Interface_Response__c(
                            Id = message.Id,
                            Treatment_Status__c = 'Error',
                            Treatment_Message__c = 'No response handler class for this interface'
                    ));
                }
            }

            for (String interfaceName : messagesByHandlingClasses.keySet()) {
                Intf_ResponseHandlerInterface instance = (Intf_ResponseHandlerInterface)Type.forName(interfaceName).newInstance();

                instance.handleResponses(messagesByHandlingClasses.get(interfaceName));
            }

            if (!interfacesNotTreatable.isEmpty()) {
                update interfacesNotTreatable;
            }
        }
    }
}
/**
 * Created by Michael on 20-03-24.
 */

public with sharing class Intf_BusinessPartnerResponseHandler implements Intf_ResponseHandlerInterface {

    private static final String TREATMENT_OK = 'Done';
    private static final String TREATMENT_ERROR = 'Error';

    public void handleResponses(List<Interface_Response__c> newMessages) {

        List<Interface_Response__c> interfaceResponsesToUpdate = new List<Interface_Response__c>();
        List<Account> accountsToUpdate = new List<Account>();
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Interface_Response__c interfaceResponse : newMessages) {

            Interface_Response__c intRepToUpdate = new Interface_Response__c(
                    Id = interfaceResponse.Id
            );

            String objectAPIName = ((Id)interfaceResponse.CRM_Number__c).getSobjectType().getDescribe().getName();
            System.debug('======= Intf_BusinessPartnerResponseHandler objectAPIName: '+ objectAPIName);
            System.debug('======= Intf_BusinessPartnerResponseHandler interfaceResponse.CRM_Number__c: '+ interfaceResponse.CRM_Number__c);

            switch on interfaceResponse.Status__c {
                when 'S' {
                    // Success

                    try {
                        if (objectAPIName == 'Account') {

                            try {
                                List<MultiContact> contactInfos = (List<MultiContact>)JSON.deserialize(interfaceResponse.Response_Message__c,List<MultiContact>.class);
                                List<Contact> contactsB2BToUpdate =  new List<Contact>();

                                for (MultiContact contactInfo : contactInfos) {
                                    contactsB2BToUpdate.add(new Contact(
                                            Id = contactInfo.salesforceContactId,
                                            SAP_ID__c = contactInfo.sapContactId,
                                            Intf_Sync_Status__c = 'Sync',
                                            Intf_Synchronisation_Message__c = null
                                    ));
                                }
                                update contactsB2BToUpdate;

                            } catch (exception e) {
                                System.debug('======= No contact info returned');
                            }

                            accountsToUpdate.add(new Account(
                                    Id = interfaceResponse.CRM_Number__c,
                                    Intf_Sync_Status__c = 'Sync',
                                    Intf_Synchronisation_Message__c = null,
                                    Tech_SAP_Id__c = interfaceResponse.ERP_Number__c

                            ));

                        } else {
                            contactsToUpdate.add(new Contact(
                                    Id = interfaceResponse.CRM_Number__c,
                                    Intf_Sync_Status__c = 'Sync',
                                    Intf_Synchronisation_Message__c = null,
                                    SAP_ID__c = interfaceResponse.ERP_Number__c
                            ));
                        }

                        intRepToUpdate.Treatment_Status__c = TREATMENT_OK;

                    } catch (Exception e) {
                        intRepToUpdate.Treatment_Status__c = TREATMENT_ERROR;
                        intRepToUpdate.Treatment_Message__c = e.getMessage();
                    }

                }
                when 'E' {
                    // Errors

                    if (objectAPIName == 'Account') {
                        accountsToUpdate.add(new Account(
                                Id = interfaceResponse.CRM_Number__c,
                                Intf_Sync_Status__c = 'Error',
                                Intf_Synchronisation_Message__c = interfaceResponse.Response_Message__c
                        ));

                    } else {

                        contactsToUpdate.add(new Contact(
                                Id = interfaceResponse.CRM_Number__c,
                                Intf_Sync_Status__c = 'Error',
                                Intf_Synchronisation_Message__c = interfaceResponse.Response_Message__c
                        ));
                    }


                    intRepToUpdate.Treatment_Status__c = TREATMENT_OK;
                }
                when else {
                    // Code inconnu

                    intRepToUpdate.Treatment_Status__c = TREATMENT_ERROR;
                    intRepToUpdate.Treatment_Message__c = 'Unknown status code';

                }
            }
            interfaceResponsesToUpdate.add(intRepToUpdate);
        }

        System.debug('======= Intf_BusinessPartnerResponseHandler accountsToUpdate: '+ accountsToUpdate);
        System.debug('======= Intf_BusinessPartnerResponseHandler contactsToUpdate: '+ contactsToUpdate);

        update accountsToUpdate;
        update contactsToUpdate;
        update interfaceResponsesToUpdate;
    }

    public class MultiContact {
        public String salesforceContactId { get; set; }
        public String sapContactId { get; set ;}
    }
}
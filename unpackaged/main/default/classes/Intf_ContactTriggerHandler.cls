public with sharing class Intf_ContactTriggerHandler {
    private static final String DEFAULT_TRIGGERING_SYNC_STATUS = System.Label.Intf_Default_Oppy_BP_Status_Sync != null ? System.Label.Intf_Default_Oppy_BP_Status_Sync : '4 - Accord de principe';
    private static final String INTERFACE_NAME = 'Account_SAP';

    public without sharing class sendLikendBPsToSAP implements Intf_Framework_Triggers.Handler {
        public void handle() {

            List<Intf_Activation__mdt> interfaceActivations = new List<Intf_Activation__mdt>([SELECT Id, Active__c FROM Intf_Activation__mdt WHERE Interface_Name__c = :INTERFACE_NAME]);

            if (!Test.isRunningTest() && (interfaceActivations.isEmpty() || interfaceActivations[0].Active__c == false)) { return; }

            Map<Id, Contact> oldContacts = (Map<Id, Contact>)Trigger.oldMap;
            List<Opportunity> b2cOppies = new List<Opportunity>();
            Map<Id, Opportunity> b2bOppies = new Map<Id, Opportunity>();
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            List<InvolvedStakeholder__c> involvedStakeholders = new List<InvolvedStakeholder__c>();
            Set<Id> oppId = new Set<Id>();
            Set<Id> accountIds = new Set<Id>();

            System.debug('========================== Intf_AccountTriggerHandler sendB2CLinkedBPs Intf_RecursiveValidator.isAlreadyDone(): ' + Intf_RecursiveValidator.isAlreadyDone());

            if (!Intf_RecursiveValidator.isAlreadyDone()) {

                List<AccountContactRelation> accountsContactRelation = [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE ContactId in :oldContacts.keySet()];
                for(AccountContactRelation accountContactRelation : accountsContactRelation) {
                    if(accountContactRelation.AccountId != null) {
                        accountIds.add(accountContactRelation.AccountId);
                    }
                }
                involvedStakeholders = [SELECT Id, InvolvedAccount__c, Role__c, Opportunity__c, Opportunity__r.SalesAreaData__c, InvolvedAccount__r.OK_Interface__c FROM InvolvedStakeholder__c WHERE InvolvedAccount__c IN :accountIds];
                for(InvolvedStakeholder__c involvedStakeholder : involvedStakeholders) {
                    if(involvedStakeholder.Opportunity__c != null) {
                        oppId.add(involvedStakeholder.Opportunity__c);
                    }
                }
                oppsToUpdate = [SELECT Id, StageName, Contact_B2C__c, CurrencyIsoCode, TypeContrat__c FROM Opportunity WHERE Id IN :oppId];
                for (Opportunity opportunity : oppsToUpdate) {
                    //if (Opportunity.StageName != oldOppies.get(opportunity.Id).StageName && Opportunity.StageName == DEFAULT_TRIGGERING_SYNC_STATUS) {
                        //Need to see if B2C or B2B Opportunity

                        if (opportunity.Contact_B2C__c != null) {
                            //B2C
                                b2cOppies.add(opportunity);
                        } else {
                            //B2B
                            b2bOppies.put(opportunity.Id, opportunity);
                        }
                   // }
                }

                System.debug('========================== Intf_OpportunityTriggerHandler handle b2bOppies: ' + b2bOppies);
                System.debug('========================== Intf_OpportunityTriggerHandler handle b2cOppies: ' + b2cOppies);

                if (!b2bOppies.isEmpty()) {
                    sendB2BLinkedBPs(b2bOppies);
                }
                if (!b2cOppies.isEmpty()) {
                    sendB2CLinkedBPs(b2cOppies);
                }

                Intf_RecursiveValidator.setAlreadyDone();
            }
        }
    }

    private static void sendB2BLinkedBPs(Map<Id, Opportunity> oppiesToSend) {

        Set<Id> accountsToSend = new Set<Id>();
        Set<Id> sadIds = new Set<Id>();
        Set<Id> saIds = new Set<Id>();
        Map<Id, InvolvedStakeholder__c> steakHolderByByAccountIds = new Map<Id, InvolvedStakeholder__c>();
        Map<Id, SalesAreaData__c> sadByIds = new Map<Id, SalesAreaData__c>();
        Map<Id, Id> sadIdsByOppyIds = new Map<Id, Id>();
        Map<Id, Id> oppyIdsByAccountIds = new Map<Id, Id>();
        Map<Id, Account> accountByIds = new Map<Id, Account>();
        Map<Id, Framework_Agreement__c> agreementsBySaIds = new Map<Id, Framework_Agreement__c>();
        Map<Id, Map<Id, Contact>> contactsByAccountIds = new Map<Id, Map<Id, Contact>>();
        Map<Id, List<String>> rolesByContactIds = new Map<Id, List<String>>();
        Set<Id> contactIds = new Set<Id>();

        for (InvolvedStakeholder__c involvedStakeholder : [SELECT Id, InvolvedAccount__c, Role__c, Opportunity__c, Opportunity__r.SalesAreaData__c, InvolvedAccount__r.OK_Interface__c FROM InvolvedStakeholder__c WHERE Opportunity__c in :oppiesToSend.keySet()]) {

            if (involvedStakeholder.InvolvedAccount__r.OK_Interface__c) {
                accountsToSend.add(involvedStakeholder.InvolvedAccount__c);
                oppyIdsByAccountIds.put(involvedStakeholder.InvolvedAccount__c, involvedStakeholder.Opportunity__c);
                sadIds.add(involvedStakeholder.Opportunity__r.SalesAreaData__c);
                sadIdsByOppyIds.put(involvedStakeholder.Opportunity__c, involvedStakeholder.Opportunity__r.SalesAreaData__c);
                steakHolderByByAccountIds.put(involvedStakeholder.InvolvedAccount__c,  involvedStakeholder);
            }
        }

        for (AccountContactRelation acr : [
                SELECT Id, Contact.Fonction__c, Contact.ServiceDepartement__c, Contact.MobilePhone, Contact.Fax, Contact.Email, Contact.Salutation, Contact.FirstName, Contact.LastName, AccountId, Contact.TECH_SAP_Language__c, Contact.SAP_ID__c, ContactId
                FROM AccountContactRelation
                WHERE AccountId in :accountsToSend
        ]) {

            if (!contactsByAccountIds.containsKey(acr.AccountId)) {
                contactsByAccountIds.put(acr.AccountId, new Map<Id, Contact>());
            }

            contactsByAccountIds.get(acr.AccountId).put(acr.ContactId, acr.Contact);
            contactIds.add(acr.ContactId);
        }

        System.debug('========================== Intf_OpportunityTriggerHandler sendB2BLinkedBPs contactsByAccountIds: ' + contactsByAccountIds);


//        for (RoleContact__c roleContact : [SELECT Id, Contact__c  FROM RoleContact__c WHERE Opportunite__c in :oppiesToSend.keySet()]) {
//            contactIds.add(roleContact.Contact__c);
//        }

        System.debug('========================== Intf_OpportunityTriggerHandler sendB2BLinkedBPs contactIds: ' + contactIds);

        for (RoleContact__c roleContact : [
                SELECT Id, Contact__c, Role__c, Contact__r.Fonction__c, Contact__r.ServiceDepartement__c, Contact__r.MobilePhone, Contact__r.Fax, Contact__r.Email, Contact__r.Salutation, Contact__r.FirstName,
                        Contact__r.LastName, Contact__r.AccountId, Contact__r.TECH_SAP_Language__c, Contact__r.SAP_ID__c
                FROM RoleContact__c
                WHERE Contact__c in :contactIds
        ]) {

            System.debug('========================== Intf_OpportunityTriggerHandler sendB2BLinkedBPs roleContact: ' + roleContact);

            if (!rolesByContactIds.containsKey(roleContact.Contact__c)) {
                rolesByContactIds.put(roleContact.Contact__c, new List<String>());
            }
            rolesByContactIds.get(roleContact.Contact__c).add(roleContact.Role__c);

        }


        for (SalesAreaData__c sad : [SELECT Id, PFRegion__c, BusinessLine__c, LegalEntityName__c, SalesArea__c, LegalEntityCode__c FROM SalesAreaData__c WHERE Id in :sadIds]) {
            saIds.add(sad.SalesArea__c);
            sadByIds.put(sad.Id, sad);
        }

        for (Framework_Agreement__c fag : [SELECT Id, Organisation_Commerciale__c, ModeFacturationCD__c, ModeFacturationLD__c, ModeFacturationMD__c, ModeReglementCD__c, ModeReglementLD__c, ModeReglementMD__c FROM Framework_Agreement__c WHERE Compte__c in :accountsToSend AND Organisation_Commerciale__c in :saIds AND Active__c = true]) {
            agreementsBySaIds.put(fag.Organisation_Commerciale__c, fag);
        }

        System.debug('========================== Intf_OpportunityTriggerHandler sendB2BLinkedBPs agreementsBySaIds: ' + agreementsBySaIds);

        accountByIds = new Map<Id, Account>([
                SELECT Id, Ligne1__c, Ligne2__c, Ligne3__c, Ligne4__c, Ville__c, CodePostal__c, Province__c, DB_ID_Prefere__c, DB_Valeur_ID_Prefere__c, CurrencyIsoCode, Pays__c, CodePays__c, Tech_SAP_Id__c,
                        NumeroCompte__c, CategorieCompte__c, NomCommercial__c, DB_Description_activite__c, LangueTravail__c, DB_Email_Contact__c, DB_Forme_Juridique_Generale__c, Name, TECH_SAP_Language__c, DB_Valeur_Taxe__c
                FROM Account
                WHERE Id in :accountsToSend
        ]);

        System.debug('========================== Intf_OpportunityTriggerHandler sendB2BLinkedBPs sadByIds: ' + sadByIds);
        System.debug('========================== Intf_OpportunityTriggerHandler sendB2BLinkedBPs sadIds: ' + sadIds);

        List<Intf_BusinessPartnerSchemaBuilder.BusinessPartnerMsg> bpMessages = new List<Intf_BusinessPartnerSchemaBuilder.BusinessPartnerMsg>();

        for (Id accountId : accountsToSend) {
            Id oppyId = oppyIdsByAccountIds.get(accountId);
            Id sadId = sadIdsByOppyIds.get(oppyId);

            InvolvedStakeholder__c involvedStakeholder = steakHolderByByAccountIds.get(accountId);
            SalesAreaData__c sad = sadByIds.get(sadId);
            Opportunity oppy = oppiesToSend.get(oppyId);

            System.debug('========================== Intf_OpportunityTriggerHandler sendB2BLinkedBPs accountByIds.get(accountId): ' + accountByIds.get(accountId));

            bpMessages.add(new Intf_BusinessPartnerSchemaBuilder.BusinessPartnerMsg(oppy, accountByIds.get(accountId), involvedStakeholder, sad, agreementsBySaIds.get(sad.SalesArea__c), contactsByAccountIds.get(accountId), rolesByContactIds));
        }

        if (!bpMessages.isEmpty()) {
            Intf_WebserviceCalloutBP intfWebserviceCalloutBP = new Intf_WebserviceCalloutBP();
            intfWebserviceCalloutBP.executeCallout(bpMessages);
        }

    }


    private static void sendB2CLinkedBPs(List<Opportunity> oppiesToSend) {


        System.debug('========================== Intf_OpportunityTriggerHandler sendB2CLinkedBPs oppiesToSend: ' + oppiesToSend);

        Set<Id> b2cContactIds = new Set<Id>();
        Set<Id> sadIds = new Set<Id>();
        Map<Id, SalesAreaData__c> sadByIds = new Map<Id, SalesAreaData__c>();

        for (Opportunity opportunity : oppiesToSend) {
            b2cContactIds.add(opportunity.Contact_B2C__c);
            sadIds.add(opportunity.SalesAreaData__c);
        }

        sadByIds = new Map<Id, SalesAreaData__c>([SELECT Id, PFRegion__c, BusinessLine__c, LegalEntityName__c, SalesArea__c, LegalEntityCode__c FROM SalesAreaData__c WHERE Id in :sadIds]);

        Map<Id, Contact> contactsById = new Map<Id, Contact>([
                SELECT Salutation, FirstName, LastName, Email, Adresse__c, Adresse_Livraison__c, Ville_Facturation__c, Ville_Livraison__c, MobilePhone, Fax, SAP_ID__c,
                        Code_Postal_Facturation__c, Code_Postal_Livraison__c, Pays_Livraison__c, Pays_Facturation__c, Ligne1_Facturation__c, Ligne1_Livraison__c, ModedePaiement__c, TECH_SAP_Language__c,
                        PaysLivraison__c, PaysFacturation__c
                FROM Contact
                WHERE Id in :b2cContactIds
        ]);

        List<Intf_BusinessPartnerSchemaBuilder.BusinessPartnerMsg> bpMessages = new List<Intf_BusinessPartnerSchemaBuilder.BusinessPartnerMsg>();

        for (Opportunity opportunity : oppiesToSend) {
            SalesAreaData__c sad = sadByIds.get(opportunity.SalesAreaData__c);
            bpMessages.add(new Intf_BusinessPartnerSchemaBuilder.BusinessPartnerMsg(opportunity, contactsById.get(opportunity.Contact_B2C__c), sad));
        }

        if (!bpMessages.isEmpty()) {
            Intf_WebserviceCalloutBP intfWebserviceCalloutBP = new Intf_WebserviceCalloutBP();
            intfWebserviceCalloutBP.executeCallout(bpMessages);
        }

    }
}
/**
 * Created by Michael on 05-05-24.
 */

@IsTest
private class Intf_InterfaceRespTriggerHandler_Test {

    @TestSetup
    static void setupData() {

        Intf_Framework_Triggers.handlerBypass('sendWorkOrderToSAP');

        Id acRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();

        Asset asset = new Asset(
                Name = 'PF-123456'
        );
        insert asset;

        SalesArea__c sa = new SalesArea__c(
                Name = 'test'
        );
        insert sa;


        Account account = new Account(
                Name = 'Agence Test',
                RecordTypeId = acRecTypeId
        );
        insert account;

        SalesAreaData__c sad = new SalesAreaData__c(
                Account__c = account.Id,
                SalesArea__c = sa.Id
        );
        insert sad;

        Id coRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Chauffeur').getRecordTypeId();

        Contact contact = new Contact(
                FirstName = 'Monsieur',
                LastName = 'Test',
                MobilePhone = '063456884',
                AccountId = account.Id,
                RecordTypeId = coRecTypeId
        );
        insert contact;

        Id woRecTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Tour_de_parc_Chapeau').getRecordTypeId();

        WorkOrder wo = new WorkOrder(
                Organe_controler__c = 'Caisse',
                Earliest_Start_Permitted__c = Datetime.now().addDays(1),
                RecordTypeId = woRecTypeId,
                AccountId = account.Id
        );
        insert wo;

        WorkOrder woChild = new WorkOrder(
                Organe_controler__c = 'Caisse',
                Earliest_Start_Permitted__c = Datetime.now().addDays(1),
                RecordTypeId = woRecTypeId,
                AccountId = account.Id,
                ParentWorkOrderId = wo.Id,
                AssetId = asset.Id
        );
        insert woChild;

        Opportunity oppy = new Opportunity(
                AccountId = account.Id,
                Name = 'Oppy Test',
                CloseDate = Date.today().addDays(5),
                StageName = '1 - Opportunité créée',
                SalesAreaData__c = sad.Id

        );
        insert oppy;

        InvolvedStakeholder__c involvedStakeholder = new InvolvedStakeholder__c(
                InvolvedAccount__c = account.Id,
                Opportunity__c = oppy.Id,
                Role__c = 'Livré'
        );
        insert involvedStakeholder;

    }

    @IsTest
    static void testWorkOrderResponse() {

        WorkOrder wo = [SELECT Id FROM WorkOrder WHERE AssetId = null];

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = wo.Id,
                ERP_Number__c = 'SAP1234',
                Status__c = 'S',
                Interface_Name__c = 'WorkOrder_SAP'
        );

        insert interfaceResponse;

        wo = [SELECT Id, Intf_Sync_Status__c, SAP_ID__c FROM WorkOrder WHERE AssetId = null];
        System.debug('============= TEST TEST TEST wo: ' + wo);

        System.assertEquals('Sync', wo.Intf_Sync_Status__c);
        System.assertEquals('SAP1234', wo.SAP_ID__c);

    }

    @IsTest
    static void testWorkOrderResponseError() {

        WorkOrder wo = [SELECT Id FROM WorkOrder WHERE AssetId = null];

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = wo.Id,
                Response_Message__c = 'Error',
                Status__c = 'E',
                Interface_Name__c = 'WorkOrder_SAP'
        );

        insert interfaceResponse;

        wo = [SELECT Id, Intf_Sync_Status__c, Intf_Synchronisation_Message__c FROM WorkOrder WHERE AssetId = null];
        System.debug('============= TEST TEST TEST wo: ' + wo);

        System.assertEquals('Error', wo.Intf_Sync_Status__c);
        System.assertEquals('Error', wo.Intf_Synchronisation_Message__c);

    }

    @IsTest
    static void testBPResponseError() {

        Account account = [SELECT Id FROM account];

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = account.Id,
                Response_Message__c = 'Error',
                Status__c = 'E',
                Interface_Name__c = 'Account_SAP'
        );

        insert interfaceResponse;

        account = [SELECT Id, Intf_Sync_Status__c, Intf_Synchronisation_Message__c FROM account];

        System.assertEquals('Error', account.Intf_Sync_Status__c);
        System.assertEquals('Error', account.Intf_Synchronisation_Message__c);

    }

    @IsTest
    static void testB2CResponseError() {

        Contact contact = [SELECT Id, Intf_Synchronisation_Message__c, Intf_Sync_Status__c FROM contact LIMIT 1];

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = contact.Id,
                Status__c = 'E',
                Interface_Name__c = 'Account_SAP',
                Response_Message__c = 'ERROR'
        );

        insert interfaceResponse;

        contact = [SELECT Id, Intf_Sync_Status__c, Intf_Synchronisation_Message__c, SAP_ID__c FROM contact];

        System.assertEquals('Error', contact.Intf_Sync_Status__c);
        System.assertEquals('ERROR', contact.Intf_Synchronisation_Message__c);

    }

    @IsTest
    static void testB2CResponse() {

        Contact contact = [SELECT Id FROM contact LIMIT 1];

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = contact.Id,
                ERP_Number__c = 'SAP1234',
                Status__c = 'S',
                Interface_Name__c = 'Account_SAP'
        );

        insert interfaceResponse;

        contact = [SELECT Id, Intf_Sync_Status__c, SAP_ID__c FROM contact];

        System.assertEquals('Sync', contact.Intf_Sync_Status__c);
        System.assertEquals('SAP1234', contact.SAP_ID__c);

    }

    @IsTest
    static void testBPRespons() {

        Account account = [SELECT Id FROM account];
        Contact contact = [SELECT Id FROM contact LIMIT 1];

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = account.Id,
                ERP_Number__c = 'SAP1234',
                Status__c = 'S',
                Interface_Name__c = 'Account_SAP',
                Response_Message__c = '[{"salesforceContactId":"' + contact.Id + '","sapContactId":"291528"}]'
        );

        insert interfaceResponse;

        account = [SELECT Id, Intf_Sync_Status__c, Tech_SAP_Id__c FROM account];

        System.assertEquals('Sync', account.Intf_Sync_Status__c);
        System.assertEquals('SAP1234', account.Tech_SAP_Id__c);

    }

    @IsTest
    static void testNoHandler() {

        Account account = [SELECT Id FROM account];

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = account.Id,
                ERP_Number__c = 'SAP1234',
                Status__c = 'S',
                Interface_Name__c = 'Test'
        );
        insert interfaceResponse;

        interfaceResponse = [SELECT Id, Treatment_Message__c, Treatment_Status__c FROM Interface_Response__c];

        System.assertEquals('No response handler class for this interface', interfaceResponse.Treatment_Message__c);
        System.assertEquals('Error', interfaceResponse.Treatment_Status__c);
    }

    @IsTest
    static void testIncomingNormalWOError() {

        WorkOrder wo = [SELECT Id FROM WorkOrder WHERE AssetId = null];

        String incomingMessage = '{"BasicData":{"sapid":"27284554","type":"Depannage_Vehicule","sapaccountid":"SAP-123454","infocontact":"Chauffeur Test -- 0634567789 -- Adresse: Rue du test 1 34566 TestVile FR","titreordre":"Depannage_Vehicule","statut":"Terminé","priorite":"Moyenne","TECH_AgenceIntervenante_Name__c":"","sfcaseid":""},"parcs":[{"organe":"Caisse","numasset":"PF-123456","notetravaux":"Je suis en panne","realtravaux":"Changement pièces","observations":"Défectueux","daterelisation":"20240325114541"},{"organe":"Caisse","numasset":"PF-123464","notetravaux":"Je suis en panne","realtravaux":"Changement pièces","observations":"Défectueux","daterelisation":"20240326140712"}]}';

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = wo.Id,
                Response_Message__c = incomingMessage,
                Status__c = 'I',
                Interface_Name__c = 'WorkOrder_SAP'
        );

        insert interfaceResponse;

        List<WorkOrder> wos = new List<WorkOrder>([SELECT Id, Intf_Sync_Status__c, Intf_Synchronisation_Message__c FROM WorkOrder WHERE SAP_ID__c = '27284554']);
        System.assert(wos.isEmpty());

        interfaceResponse = [SELECT Id, Treatment_Message__c, Treatment_Status__c FROM Interface_Response__c];
        System.assertEquals('Error', interfaceResponse.Treatment_Status__c);
        System.assert(interfaceResponse.Treatment_Message__c.contains('Pas de compte'));

    }

    @IsTest
    static void testIncomingNormalWO() {

        Account account = [SELECT Id, Tech_SAP_Id__c FROM account];
        account.Tech_SAP_Id__c = 'SAP-123454';
        update account;

        WorkOrder wo = [SELECT Id FROM WorkOrder WHERE AssetId = null];

        String incomingMessage = '{"BasicData":{"sapid":"27284554","type":"Depannage_Vehicule","sapaccountid":"SAP-123454","infocontact":"Chauffeur Test -- 0634567789 -- Adresse: Rue du test 1 34566 TestVile FR","titreordre":"Depannage_Vehicule","statut":"Terminé","priorite":"Moyenne","TECH_AgenceIntervenante_Name__c":"","sfcaseid":""},"parcs":[{"organe":"Caisse","numasset":"PF-123456","notetravaux":"Je suis en panne","realtravaux":"Changement pièces","observations":"Défectueux","daterelisation":"20240325114541"},{"organe":"Caisse","numasset":"PF-123464","notetravaux":"Je suis en panne","realtravaux":"Changement pièces","observations":"Défectueux","daterelisation":"20240326140712"}]}';

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                CRM_Number__c = wo.Id,
                Response_Message__c = incomingMessage,
                Status__c = 'I',
                Interface_Name__c = 'WorkOrder_SAP'
        );

        insert interfaceResponse;

        wo = [SELECT Id, Intf_Sync_Status__c, SAP_ID__c FROM WorkOrder WHERE SAP_ID__c = '27284554'];
        System.assertEquals('27284554', wo.SAP_ID__c);

        interfaceResponse = [SELECT Id, Treatment_Message__c, Treatment_Status__c FROM Interface_Response__c];
        System.assertEquals('Done', interfaceResponse.Treatment_Status__c);

    }

    @IsTest
    static void testIncomingYardCheck() {

        Account account = [SELECT Id, Tech_SAP_Id__c FROM account];
        account.Tech_SAP_Id__c = 'SAP-123454';
        update account;


        String incomingMessage = '{"BasicData":{"sapid":"27284554","type":"Tour_de_parc","sapaccountid":"SAP-123454","infocontact":"Chauffeur Test -- 0634567789 -- Adresse: Rue du test 1 34566 TestVile FR","titreordre":"Tour_de_parc","statut":"Terminé","priorite":"Moyenne","TECH_AgenceIntervenante_Name__c":"","sfcaseid":""},"parcs":[{"organe":"Caisse","numasset":"PF-123456","notetravaux":"Je suis en panne","realtravaux":"Changement pièces","observations":"Défectueux","daterelisation":"20240325114541"}]}';

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                Response_Message__c = incomingMessage,
                Status__c = 'I',
                Interface_Name__c = 'WorkOrder_SAP'
        );

        insert interfaceResponse;

        List<WorkOrder> wos = new List<WorkOrder>([SELECT Id, Intf_Sync_Status__c, SAP_ID__c FROM WorkOrder WHERE SAP_ID__c = '27284554']);
        System.assertEquals('27284554', wos[0].SAP_ID__c);

        List<WorkOrder> woChildren = new List<WorkOrder>([SELECT Id, Intf_Sync_Status__c, ParentWorkOrderId, Asset.Name FROM WorkOrder WHERE ParentWorkOrderId = :wos[0].Id]);
        System.debug('============== TEST TEST TEST woChildren : ' + woChildren);
        System.assertEquals('PF-123456', woChildren[0].Asset.Name);

        interfaceResponse = [SELECT Id, Treatment_Message__c, Treatment_Status__c FROM Interface_Response__c];
        System.assertEquals('Done', interfaceResponse.Treatment_Status__c);

    }

    @IsTest
    static void testIncomingYardCheckUpate() {

        Account account = [SELECT Id, Tech_SAP_Id__c FROM account];
        account.Tech_SAP_Id__c = 'SAP-123454';
        update account;

        WorkOrder wo = [SELECT Id, SAP_ID__c FROM WorkOrder WHERE AssetId = null];
        wo.SAP_ID__c = '27284554';
        update wo;

        String incomingMessage = '{"BasicData":{"sapid":"27284554","type":"Tour_de_parc","sapaccountid":"SAP-123454","infocontact":"Chauffeur Test -- 0634567789 -- Adresse: Rue du test 1 34566 TestVile FR","titreordre":"Tour_de_parc","statut":"Terminé","priorite":"Moyenne","TECH_AgenceIntervenante_Name__c":"","sfcaseid":""},"parcs":[{"organe":"Caisse","numasset":"PF-123456","notetravaux":"Je suis en panne","realtravaux":"Changement pièces","observations":"Défectueux","daterelisation":"20240325114541"}]}';

        Interface_Response__c interfaceResponse = new Interface_Response__c(
                Response_Message__c = incomingMessage,
                Status__c = 'I',
                Interface_Name__c = 'WorkOrder_SAP'
        );

        insert interfaceResponse;

        List<WorkOrder> wos = new List<WorkOrder>([SELECT Id, Intf_Sync_Status__c, SAP_ID__c, Status FROM WorkOrder WHERE SAP_ID__c = '27284554']);
        System.debug('============== TEST TEST TEST wos : ' + wos);
        System.assertEquals('Terminé', wos[0].Status);

        List<WorkOrder> woChildren = new List<WorkOrder>([SELECT Id, Intf_Sync_Status__c, ParentWorkOrderId, Asset.Name, Status  FROM WorkOrder WHERE ParentWorkOrderId = :wos[0].Id]);
        System.debug('============== TEST TEST TEST woChildren : ' + woChildren);
        System.assertEquals('Terminé', woChildren[0].Status);

        interfaceResponse = [SELECT Id, Treatment_Message__c, Treatment_Status__c FROM Interface_Response__c];
        System.debug('============== TEST TEST TEST Treatment_Message__c : ' + interfaceResponse.Treatment_Message__c);
        System.assertEquals('Done', interfaceResponse.Treatment_Status__c);

    }
}
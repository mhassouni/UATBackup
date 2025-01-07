@IsTest(SeeAllData=true)
private class DataTableWrapperController_Test {
    
    @IsTest
    static void testGetRecords() {
        // Définir des données de test
        String objectName = 'Note_satisfaction_client__c'; // Remplacez par l'objet Salesforce requis pour le test
        String fieldsToQuery = 'Id, Name'; // Champs à interroger
        String filters = ''; // Filtres pour la requête
        String fieldToOrder = 'Name'; // Champ pour l'ordre
        // Appel à la méthode à tester
        List<SObject> records = DataTableWrapperController.getRecords(objectName, fieldsToQuery, filters, fieldToOrder);
    }
    
      @IsTest
    static void testGetFieldDetails() {
        // Définir des données de test
        String objectName = 'Note_satisfaction_client__c'; // Remplacez par l'objet Salesforce requis pour le test
        String fieldsToQuery = 'Name'; // Champs pour récupérer les détails
        String fieldsToQuery2 = 'Compte__r.Name'; // Champs pour récupérer les détails
        String filters = 'SomeValue'; // Filtres pour la requête
        // Appel à la méthode à tester
        Map<String, Map<String, String>> fieldDetails = DataTableWrapperController.getFieldDetails(objectName, fieldsToQuery, filters);
        Map<String, Map<String, String>> fieldDetails2 = DataTableWrapperController.getFieldDetails(objectName, fieldsToQuery2, filters);
    }
    
    @IsTest
    static void testGetRelationshipFieldName() {
        // Définir le nom d'une relation avec et sans '__r'
        String relationshipNameWithR = 'CustomObject__r';
        String relationshipNameWithoutR = 'CustomObject';

        // Appeler la méthode à tester avec et sans '__r'
        String fieldNameWithR = DataTableWrapperController.getRelationshipFieldName(relationshipNameWithR);
        String fieldNameWithoutR = DataTableWrapperController.getRelationshipFieldName(relationshipNameWithoutR);

        // Vérifier les résultats
        System.assertEquals('CustomObject__c', fieldNameWithR, 'Le nom du champ de relation avec "__r" doit être converti correctement');
        System.assertEquals('CustomObjectid', fieldNameWithoutR, 'Le nom du champ de relation sans "__r" doit être converti correctement');
    }
    
    @IsTest
    static void testBuildSFTypeToJsTypeMap() {
        Map<Schema.DisplayType, String> expectedMap = new Map<Schema.DisplayType, String>{
            Schema.DisplayType.BOOLEAN => 'boolean',
            Schema.DisplayType.COMBOBOX => 'text',
            Schema.DisplayType.CURRENCY => 'currency',
            Schema.DisplayType.DATACATEGORYGROUPREFERENCE => 'text',
            Schema.DisplayType.DATE => 'date',
            Schema.DisplayType.DOUBLE => 'number',
            Schema.DisplayType.EMAIL => 'email',
            Schema.DisplayType.ID => 'text',
            Schema.DisplayType.INTEGER => 'number',
            Schema.DisplayType.LONG => 'number',
            Schema.DisplayType.MULTIPICKLIST => 'text',
            Schema.DisplayType.PERCENT => 'number',
            Schema.DisplayType.PHONE => 'phone',
            Schema.DisplayType.PICKLIST => 'text',
            Schema.DisplayType.REFERENCE => 'id',
            Schema.DisplayType.STRING => 'text',
            Schema.DisplayType.TEXTAREA => 'text',
            Schema.DisplayType.TIME => 'text',
            Schema.DisplayType.URL => 'url'
        };

        // Appeler la méthode à tester
        Map<Schema.DisplayType, String> result = DataTableWrapperController.buildSFTypeToJsTypeMap();

        // Vérifier que le résultat correspond à la map attendue
        System.assertEquals(expectedMap, result, 'La map générée doit correspondre à la map attendue');
    }
    
    
    @IsTest
    static void testGetAccountDataWithoutSpecifyingId() {
        Test.startTest();
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 1]; // Vous pouvez ajuster la requête en fonction de vos besoins
        DataTableWrapperController.getAccountData(accounts[0].id);
        DataTableWrapperController.getBusinessLinesData(accounts[0].id);
        Test.stopTest();
    }


@IsTest
    static void testUpdateRecords() {
        // Créer des enregistrements simulés à mettre à jour
        List<Map<String, Object>> recordsToUpdate = new List<Map<String, Object>>();
        List<Note_satisfaction_client__c> NotesSatisfactionClient = [SELECT Id, Name, Annees_des_enquetes__c, Note_globale_PF__c, Interroge_qualite_client__c, Note_satisfaction_client_Field__c, Evolution_note_satisfaction__c FROM Note_satisfaction_client__c LIMIT 1]; // Vous pouvez ajuster la requête en fonction de vos besoins

        // Créer un enregistrement simulé
        Map<String, Object> record1 = new Map<String, Object>{
            'sobjectType' => 'Note_satisfaction_client__c', // Type d'objet à mettre à jour (Account dans cet exemple)
            'Id' => NotesSatisfactionClient[0].id, // ID de l'enregistrement à mettre à jour
            'Name' => 'New Account Name',
            'Annees_des_enquetes__c' => 'New Account Name',
            'Note_globale_PF__c' => 0,
            'Interroge_qualite_client__c' => 'Meuble',
            'Note_satisfaction_client_Field__c' => 0,
            'Evolution_note_satisfaction__c' => 'New Account Name'
                };
        recordsToUpdate.add(record1);

        // Créer une instance de la classe de contrôleur
        DataTableWrapperController.updateRecords(recordsToUpdate);
    }
}
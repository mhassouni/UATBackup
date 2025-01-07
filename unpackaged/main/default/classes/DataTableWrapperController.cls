/**
* DataTableWrapperController helps getting Salesforce records and field related daata.
*
* @version   1.0
* @since     2020-04-05 
*/
public with sharing class DataTableWrapperController {

    /**
    * getRecords build the SOQL query, exucutes it and return the results
    * @param API Name of the Object
    * @param List of field in comma separated form
    * @param SOQL filter in String form
    * @return SObject records returned after running the query
    */
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectName, String fieldsToQuery, String filters, String fieldToOrder){
        String query = 'SELECT ' + fieldsToQuery + ' FROM ' + objectName;
        if (String.isNotBlank(filters)){
            query += ' WHERE Compte__c = \'' + filters + '\'' ;
        }
        if (String.isNotBlank(fieldToOrder)){
            query += ' ORDER BY ' + fieldToOrder;
        }
        
        return Database.query(query);
    }

    /**
    * getFieldDetails gets the details about Object fields
    * @param API Name of the Object
    * @param List of field in comma separated form
    * @param SOQL filter in String form
    * @return Map between object fields and their details that can be used on JS Controller
    */
    @AuraEnabled(cacheable=true)
    public static Map<String,Map<String, String>> getFieldDetails(String objectName, String fieldsToQuery, String filters){
        //Covert Object and Field Names to Lower case
        objectName = objectName.toLowerCase();
        fieldsToQuery = fieldsToQuery.toLowerCase();

        Map<Schema.DisplayType, String> fieldDisplayTypeToJsTypeMap = buildSFTypeToJsTypeMap();
        Map<String, Map<String, String>> fieldNameToDetailsMap = new Map<String, Map<String, String>>();
        DescribeSObjectResult objectResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objectResult.fields.getMap();
        
        for (String fieldName : fieldsToQuery.split(',')) {
            fieldName = fieldName.replace(' ','');
            if (fieldMap.containsKey(fieldName)) {
                Schema.DescribeFieldResult fieldDescribeResult = fieldMap.get(fieldName).getDescribe();
                Schema.DisplayType displayType = fieldDescribeResult.getType();
                String fieldLabel = fieldDescribeResult.getLabel();
                String apiName = fieldDescribeResult.getName();
                if (fieldDisplayTypeToJsTypeMap.containsKey(displayType)) {
                    Map<String, String> fieldDetailsMap = new Map<String, String>(); 
                    fieldDetailsMap.put('label', fieldLabel);
                    fieldDetailsMap.put('apiname', apiName);
                    fieldDetailsMap.put('displaytype', fieldDisplayTypeToJsTypeMap.get(displayType));
                    fieldDetailsMap.put('objectPluralName', objectResult.getLabelPlural());
                    fieldNameToDetailsMap.put(fieldName, fieldDetailsMap);
                }
            } else {
                //Check for relationship and get base field Name
                if (fieldName.contains('.')) {
                    List<String> splitFieldRelationshipAndName = fieldName.split('\\.');
                    String relationshipName = splitFieldRelationshipAndName.get(0);
                    String relatedField = splitFieldRelationshipAndName.get(1);
                    String relationshipField = getRelationshipFieldName(relationshipName);
                    if (String.isnotBlank(relationshipField)) {
                        if (fieldMap.containsKey(relationshipField)) {
                            Schema.DescribeFieldResult fieldDescribeResult = fieldMap.get(relationshipField).getDescribe();
                            String relationShipFieldLabel = fieldDescribeResult.getLabel();
                            String relationFieldApiName = fieldDescribeResult.getRelationshipName();
                            Schema.sObjectType referencedObject = fieldDescribeResult.getReferenceTo().get(0);
                            Map<String, Schema.SObjectField> relationshipFieldMap = referencedObject.getDescribe().fields.getMap();
                            if (relationshipFieldMap.containsKey(relatedField)) {
                                Schema.DescribeFieldResult relationFieldDescribeResult = relationshipFieldMap.get(relatedField).getDescribe();
                                Schema.DisplayType displayType = relationFieldDescribeResult.getType();
                                String fieldLabel = relationFieldDescribeResult.getLabel();
                                String apiName = relationFieldDescribeResult.getName();
                                if (fieldDisplayTypeToJsTypeMap.containsKey(displayType)) {
                                    Map<String, String> fieldDetailsMap = new Map<String, String>(); 
                                    fieldDetailsMap.put('label', relationShipFieldLabel + ' - ' + fieldLabel);
                                    fieldDetailsMap.put('apiname', relationFieldApiName + '_' + apiName);
                                    fieldDetailsMap.put('displaytype', fieldDisplayTypeToJsTypeMap.get(displayType));
                                    fieldDetailsMap.put('objectPluralName', objectResult.getLabelPlural());
                                    fieldNameToDetailsMap.put(fieldName, fieldDetailsMap);
                                }
                            }
                        }
                    }
                }
            }
        }
        return fieldNameToDetailsMap;
    }

    /**
    * Get the Custom field name from the Relationship Name
    * @param Relationship Name
    * @return API Nme of the relationship field
    */
    public static String getRelationshipFieldName(String relationshipName) {
        String relationshipFieldName = '';
        //Verify if field contains the relationship
        if (relationshipName.endsWith('__r')) {
            relationshipFieldName = relationshipName.replace('__r', '__c');
        } else {
            relationshipFieldName = relationshipName + 'id';
        }
        return relationshipFieldName;
    }

    /**
    * Build a mapping between SF Data Type and JS Type
    * @param Relationship Name
    * @return API Nme of the relationship field
    */
    public static Map<Schema.DisplayType, String> buildSFTypeToJsTypeMap() {
        Map<Schema.DisplayType, String> fieldDisplayTypeToJsTypeMap = new Map<Schema.DisplayType, String>();
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.BOOLEAN, 'boolean');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.COMBOBOX, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.CURRENCY, 'currency');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.DATACATEGORYGROUPREFERENCE, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.DATE, 'date');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.DOUBLE, 'number');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.EMAIL, 'email');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.ID, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.INTEGER, 'number');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.LONG, 'number');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.MULTIPICKLIST, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.PERCENT, 'number');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.PHONE, 'phone');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.PICKLIST, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.REFERENCE, 'id');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.STRING, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.TEXTAREA, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.TIME, 'text');
        fieldDisplayTypeToJsTypeMap.put(Schema.DisplayType.URL, 'url');
        return fieldDisplayTypeToJsTypeMap;
    }

    @AuraEnabled
    public static void updateRecords(List<Map<String, Object>> recordsToUpdate) 
    {
        List<SObject> updatedRecords = new List<SObject>();
    
        for (Map<String, Object> record : recordsToUpdate) {
            SObject objToUpdate = (SObject)Type.forName(String.valueOf(record.get('sobjectType'))).newInstance();
            String recordId = String.valueOf(record.get('Id'));
    
            if (!String.isBlank(recordId)) {
                objToUpdate.put('Id', recordId);
    
                for (String fieldName : record.keySet()) {
                    if (!fieldName.equals('Id') && !fieldName.equals('sobjectType')) {
                        Object fieldValue = record.get(fieldName);
                        Schema.DescribeFieldResult fieldDescribe = objToUpdate.getSObjectType().getDescribe().fields.getMap().get(fieldName).getDescribe();
    
                        if (fieldValue != null) {
                            if (fieldDescribe.isUpdateable()) {
                                try {
                                    if (fieldDescribe.getType() == Schema.DisplayType.Currency && fieldValue instanceof String) {
                                        fieldValue = Decimal.valueOf((String) fieldValue);
                                    } else if (fieldDescribe.getType() == Schema.DisplayType.Double && fieldValue instanceof String) {
                                        fieldValue = Double.valueOf((String) fieldValue);
                                    } else if (fieldDescribe.getType() == Schema.DisplayType.Integer && fieldValue instanceof String) {
                                        fieldValue = Integer.valueOf((String) fieldValue);
                                    } else if (fieldDescribe.getType() == Schema.DisplayType.Date && fieldValue instanceof String) {
                                        fieldValue = Date.valueOf((String) fieldValue);
                                    } else if (fieldDescribe.getType() == Schema.DisplayType.DateTime && fieldValue instanceof String) {
                                        fieldValue = DateTime.valueOfGmt((String) fieldValue);
                                    } else if (fieldDescribe.getType() == Schema.DisplayType.Boolean && fieldValue instanceof String) {
                                        if (((String) fieldValue).equalsIgnoreCase('true') || ((String) fieldValue).equalsIgnoreCase('false')) {
                                            fieldValue = ((String) fieldValue).equalsIgnoreCase('true');
                                        }
                                    }
                                    // Ajouter d'autres conversions de types si nécessaire
    
                                    objToUpdate.put(fieldName, fieldValue);
                                } catch (Exception e) {
                                    throw new AuraHandledException('Erreur de conversion de type pour le champ ' + fieldName + ' : ' + e.getMessage());
                                }
                            } else {
                                // Gérer les champs non modifiables si nécessaire
                            }
                        }
                    }
                }
    
                updatedRecords.add(objToUpdate);
            } else {
                throw new AuraHandledException('ID manquant pour la mise à jour.');
            }
        }
    
        try {
            update updatedRecords;
        } catch (Exception e) {
            throw new AuraHandledException('Une erreur s\'est produite lors de la mise à jour des enregistrements : ' + e.getMessage());
        }
    }
    
    	@AuraEnabled(Cacheable = true)
	public static List<SalesAreaData__c> getBusinessLinesData(String recordId){
	  return [SELECT Id, CAYTD__c, CAN1YTD__c, CAN1FY__c, BusinessLine__c, Total_Contrats_echeance_CD__c, Total_Contrats_echeance_LD__c, Total_Contrats_echeance_MD__c, NbContratCDN1YTD__c, NbContratCDN1FY__c, NbContratMDN1YTD__c, NbContratMDN1FY__c, NbContratLDN1YTD__c, NbContratLDN1FY__c, NbContratCDYTD__c, NbContratMDYTD__c, NbContratLDYTD__c, TotalContratsActifs__c FROM SalesAreaData__c where  Account__c = :recordId];
	}
    
    
    @AuraEnabled(Cacheable = true)
	public static List<Account> getAccountData(String recordId)
    {
        return [SELECT Id, NbContractYTD__c, NbContractN1FY__c, CAYTDTotal__c, CAN1YTDTotal__c, CAN1FYTotal__c FROM Account where  id = :recordId];
	}
}
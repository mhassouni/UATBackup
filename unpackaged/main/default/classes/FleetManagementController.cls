public class FleetManagementController {
  
  /************************************* READ *************************************/

  /*********** FIELD SETS  ***********/

  @AuraEnabled
  public static List<Field> getFieldSet(String objectName, String fieldSetName) {
    List<Field> fields = new List<Field>();
    Schema.DescribeSObjectResult obj = Schema.getGlobalDescribe().get(objectName).getDescribe();
    for (Schema.FieldSetMember fsm : obj.FieldSets.getMap().get(fieldSetName).getFields()) {
      if (fsm.getFieldPath() == 'RecordTypeId') {
        fields.add(new Field(fsm.getFieldPath(),
                            fsm.getLabel(),
                            String.valueOf(fsm.getType()),
                            fsm.getRequired(),
                            null,
                            getRecordTypes_bis(objectName)
                            )
                    );
      } 
      else {
        fields.add(new Field(fsm.getFieldPath(),
                            fsm.getLabel(),
                            String.valueOf(fsm.getType()),
                            fsm.getRequired(),
                            (String.valueOf(fsm.getType()) == 'String'
                              ? fsm.getSObjectField().getDescribe().getLength()
                              : null),
                            ((String.valueOf(fsm.getType()) == 'Picklist' ||
                              String.valueOf(fsm.getType()) == 'MultiPicklist')
                              ? getFieldPicklistEntries(
                                  fsm.getSObjectField().getDescribe().getPicklistValues()
                                )
                              : null)
                            )
                    );
      }
    }
    return fields;
  }

  /*********** RECORD TYPES ***********/

  @AuraEnabled
  public static Map<Id, String> getRecordTypes(String objectName) {
    Map<Id, String> recordTypesById = new Map<Id, String>();
    Schema.DescribeSObjectResult obj = Schema.getGlobalDescribe().get(objectName).getDescribe();
    for (Schema.RecordTypeInfo rt : obj.getRecordTypeInfosById().values()) {
      if (!rt.isMaster() && rt.isActive())
        recordTypesById.put(rt.getRecordTypeId(), rt.getName());
    }
    return recordTypesById;
  }

  @AuraEnabled
  public static List<Option> getRecordTypes_bis(String objectName) {
    List<Option> options = new List<Option>();
    Schema.DescribeSObjectResult obj = Schema.getGlobalDescribe().get(objectName).getDescribe();
    for (Schema.RecordTypeInfo rt : obj.getRecordTypeInfosById().values()) {
      if (!rt.isMaster() && rt.isActive())
        options.add(new Option(rt.getRecordTypeId(), rt.getName()));
    }
    return options;
  }

  /*********** PICKLISTS ***********/

  public static List<Option> getFieldPicklistEntries(List<Schema.PicklistEntry> picklistEntries) {
    List<Option> options = new List<Option>();
    for (Schema.PicklistEntry ple : picklistEntries) {
      if (ple.isActive())
        options.add(new Option(ple.getValue(), ple.getLabel(), ple.isDefaultValue()));
    }
    return options;
  }

  /*********** RECORDS ***********/


  /**** HOLIDAYS ****/

  @AuraEnabled
  public static List<Holiday> getHolidayRecords() {
    return [SELECT ActivityDate, Name FROM Holiday];
  }

  /**** RESERVATIONS ****/

  @AuraEnabled
  public static List<Reservation__c> getReservations(List<Field> searchFields, List<Field> resultFields, Id orderId, Reservation__c filter) {
    System.debug('###getReservations');
    System.debug('#searchFields : ' + searchFields);
    System.debug('#resultFields : ' + resultFields);
    System.debug('#orderId : ' + orderId);
    System.debug('#filter : ' + filter);

    //Select
    String query = 'Select Id, Name, Commande__c, ';
    String criteria = '';

    //Search fields
    Object value;
    for (Field field : searchFields) {
      if (!query.contains(field.apiName)) {
        query += field.apiName + ', ';
      }
      if (filter != null) {
        System.debug('##field.apiName : ' + field.apiName);
        System.debug('##field.fieldType : ' + field.fieldType);
        System.debug('##value : ' + filter.get(field.apiName));
        
        value = filter.get(field.apiName);
        if (value != null && value != '') {
          if (field.fieldType == 'String' || field.fieldType == 'TextArea') {
            criteria += field.apiName + ' LIKE \'%' + value + '%\' AND ';
          } 
          else if (field.fieldType == 'Date') {
            if (field.apiName == 'Date_de_debut__c')
              criteria += field.apiName + ' >= ' + ((DateTime) value).format('yyyy-MM-dd') + ' AND ';
            else if (field.apiName == 'Date_de_fin__c')
              criteria += field.apiName + ' <= ' + ((DateTime) value).format('yyyy-MM-dd') + ' AND ';
            else criteria += field.apiName + ' = ' + ((DateTime) value).format('yyyy-MM-dd') + ' AND ';
          } 
          else if (field.fieldType == 'DateTime') {
            criteria += field.apiName + ' = ' + ((DateTime) value).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'') + ' AND ';
          } 
          else if (field.fieldType == 'Time') {
            criteria += field.apiName + ' = ' + ((DateTime) value).format('\'T\'hh:mm:ss\'z\'') + ' AND ';
          } 
          else if (field.fieldType == 'Picklist' || field.apiName == 'RecordTypeId') {
            criteria += '(';
            for (String option : String.valueOf(value).split(';')) {
              criteria += field.apiName + ' = \'' + String.escapeSingleQuotes(option) + '\' OR ';
            }
            criteria = criteria.SubStringBeforeLast('OR');
            criteria += ') AND ';
          } 
          else if (field.fieldType == 'Currency' || field.fieldType == 'Percent' || field.fieldType == 'Boolean' ||
            field.fieldType == 'Integer' || field.fieldType == 'Double' || field.fieldType == 'Long') {
            criteria += field.apiName + ' = ' + value + ' AND ';
          } 
          else {
            criteria += field.apiName + ' = \'' + value + '\' AND ';
          }
        }
      }
    }

    //Result fields
    for (Field field : resultFields) {
      if (!query.contains(field.apiName)) {
        query += field.apiName + ', ';
      }
    }

    query = query.SubStringBeforeLast(',');

    //FROM
    query += ' FROM Reservation__c';
    System.debug('#query without criteria: ' + query);

    //WHERE
    //if(orderId != null) criteria += ' Commande__c = \'' + orderId + '\'';
    if (!String.isEmpty(criteria)) {
      criteria = criteria.SubStringBeforeLast('AND');
      query += ' WHERE (' + criteria + ')';
    }
    System.debug('#criteria : ' + criteria);
    System.debug('#query with criteria: ' + query);

    //ORDER BY / LIMIT
    query += ' ORDER BY Date_de_debut__c LIMIT 30';

    return Database.query(query);
  }

  @AuraEnabled
  public static List<Reservation__c> getReservationsFSL(String assetIds) {
    List<Reservation__c> reservations = new List<Reservation__c>();
    if (assetIds != '') {
      List<String> assetIdsList = assetIds.split(';');
      reservations = [SELECT Name, Asset_assigne__r.Name, Asset_assigne__r.Account.Name, Asset_assigne__r.Agence_Localisation__r.Name,
                      	Date_de_debut__c, Date_de_fin__c, Status__c,
                        Type_Atelier__c, Type_de_transport__c, Type_de_location__c, Type__c, 
                        Shipping_Address__c, Shipping_City__c,
                        Description_Gantt__c, Record_Type_Name__c, RecordType.DeveloperName
                      FROM Reservation__c
                      WHERE Asset_assigne__c IN :assetIdsList ORDER BY Asset_assigne__r.Name ];
    }
    return reservations;
  }

  private static String getReservationQuery(Id assetId) {
    String queryString;
    if (assetId == null) {
      queryString = 'SELECT Name, Date_de_debut__c, Date_de_fin__c, Client__c, Client__r.Name, Description_Gantt__c, Record_Type_Name__c, RecordType.DeveloperName, Type_Atelier__c, Type_de_transport__c, Status__c FROM Reservation__c where Date_de_debut__c != null and Date_de_fin__c != null and Asset_assigne__c != null';
    } else {
      queryString =
        'SELECT Name, Date_de_debut__c, Date_de_fin__c,Client__c, Client__r.Name, Description_Gantt__c, Record_Type_Name__c, RecordType.DeveloperName,Type_Atelier__c, Type_de_transport__c, Status__c FROM Reservation__c where Date_de_debut__c != null and Date_de_fin__c != null and Asset_assigne__c = \'' +
        assetId +
        '\'';
    }
    queryString += ' ORDER BY Date_de_debut__c DESC LIMIT 5000';
    System.debug('getReservationQuery - queryString: ' + queryString);
    return queryString;
  }

  @AuraEnabled
  public static List<sObject> getReservationSObjects(Id assetId) {
    System.debug('getReservationSObjects - assetId: ' + assetId);
    return Database.query(getReservationQuery(assetId));
  }

  /**** CONTAINERS (ASSETS) ****/

  @AuraEnabled
  public static List<Asset> getAssets(List<Field> searchFields, List<Field> resultFields, Id orderId, Asset filter) {
    System.debug('###getAssets');
    System.debug('#searchFields : ' + searchFields);
    System.debug('#resultFields : ' + resultFields);
    System.debug('#orderId : ' + orderId);
    System.debug('#filter : ' + filter);

    String parcRTID = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Parc_Container').getRecordTypeId();

    //Select
    String query = 'Select Id,  ';
    String criteria = '';
    
     

    //Search fields
    Object value;
    Boolean statusDefined = false;
    for (Field field : searchFields) {
      if (!query.contains(field.apiName)) {
        query += field.apiName + ', ';
      }
      if (filter != null) {
        value = filter.get(field.apiName);
        
        if(field.apiName != 'Date_de_debut_asset__c' && field.apiName != 'Date_de_fin_asset__c') {
          if (value != null && value != '') {
            
            /* START Exception */
            if (field.apiName == 'Name') {
              criteria += field.apiName + ' = \'' + value + '\' AND ';
            } 
             else if ( field.fieldType == 'PICKLIST' && field.apiName == 'Neuf_ou_parc__c') {
              criteria += '(';
              for (String option : String.valueOf(value).split(';')) {
                criteria += ' Type_de_parc__c = \'' + String.escapeSingleQuotes(option) + '\' OR ';
              }
              criteria = criteria.SubStringBeforeLast('OR');
              criteria += ') AND ';
            } 
            else if (field.apiName == 'Parc__c') {
              criteria += ' Id = \'' + value + '\' AND ';
            } 
            else if (field.apiName == 'Options__c') {
              criteria += '(';
              for (String option : ((String) value).split(';')) {
                criteria += field.apiName + ' LIKE \'%' + String.escapeSingleQuotes(option) + '%\' OR ';
              }
              criteria = criteria.SubStringBeforeLast('OR');
              criteria += ') AND ';
            } 
            else if (field.apiName == 'Status_de_location__c') {
              if (filter.get('Date_de_debut_asset__c') == null && filter.get('Date_de_fin_asset__c') == null) {
                criteria += '(';
                for (String option : String.valueOf(value).split(';')) {
                  criteria += field.apiName + ' = \'' + String.escapeSingleQuotes(option) + '\' OR ';
                }
                criteria = criteria.SubStringBeforeLast('OR');
                criteria += ') AND ';
              }
              statusDefined = true;
            } 
            /* END Exception */

            else if ( field.fieldType == 'String' || field.fieldType == 'TextArea') {
              criteria += field.apiName + ' LIKE \'%' + value + '%\' AND ';
            } 
            else if (field.fieldType == 'Date') {
              criteria += field.apiName + ' = ' + ((DateTime) value).format('yyyy-MM-dd') +' AND ';
            } 
            else if (field.fieldType == 'DateTime') {
              criteria += field.apiName + ' = ' + ((DateTime) value).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'') + ' AND ';
            } 
            else if (field.fieldType == 'Time') {
              criteria += field.apiName + ' = ' + ((DateTime) value).format('\'T\'hh:mm:ss\'z\'') + ' AND ';
            }
            else if ( (field.fieldType == 'Picklist' && field.apiName<>'Neuf_ou_parc__c') || field.apiName == 'RecordTypeId') {
              criteria += '(';
              for (String option : String.valueOf(value).split(';')) {
                criteria += field.apiName + ' = \'' + String.escapeSingleQuotes(option) + '\' OR ';
              }
              criteria = criteria.SubStringBeforeLast('OR');
              criteria += ') AND ';
            } 
            else if (field.fieldType == 'Currency' || field.fieldType == 'Percent' || field.fieldType == 'Boolean' || 
                  field.fieldType == 'Integer' || field.fieldType == 'Double' || field.fieldType == 'Long') {
              criteria += field.apiName + ' = ' + value + ' AND ';
            } 
            else {
              criteria += field.apiName + ' = \'' + value + '\' AND ';
            }
          }
        }
      }
    }

    if (filter != null) {
      Object startDate = filter.get('Date_de_debut_asset__c');
      Object endDate = filter.get('Date_de_fin_asset__c');
      if (startDate != null || endDate != null) {
        if (statusDefined && filter.get('Status_de_location__c') != 'Disponible;') {
          criteria += ' Id IN (SELECT Asset_assigne__c FROM Reservation__c ';
          if(startDate != null && endDate != null){
            criteria += 'WHERE (';
            criteria += '(Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(startDate != null){
            criteria += 'WHERE (';
            criteria += 'Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(endDate != null){
              
            criteria += 'WHERE (';
            criteria += 'Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }

          if (filter.get('Status_de_location__c') != 'Non disponible;') {
            criteria += ' AND (';
            for (String option : ((String) filter.get('Status_de_location__c')).split(';')) {
              criteria += ' RecordType.Name LIKE \'%' + option.replace('En ', '') + '%\' OR ';
            }
            criteria = criteria.SubStringBeforeLast('OR');
            criteria += ')) AND ';
          } 
          else {
            criteria += ') AND ';
          }
        } 
        else {
          criteria += ' Status_de_location__c != \'Cession\' AND ';
          criteria += ' Id NOT IN (SELECT Asset_assigne__c FROM Reservation__c ';
          if(startDate != null && endDate != null){
            criteria += 'WHERE (';
            criteria += '(Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(startDate != null){
            criteria += 'WHERE (';
            criteria += 'Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(endDate != null){
            criteria += 'WHERE (';
            criteria += 'Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          criteria += ') AND ';
        }
      } 
      else if (!statusDefined) {
        criteria += ' Status_de_location__c = \'Disponible\' AND ';
      }
    } 
    else {
      criteria += ' Status_de_location__c = \'Disponible\' AND ';
       
      //criteria += ' Id NOT IN (SELECT Asset_assigne__c FROM Reservation__c) AND ';
    }

    //Result fields
    for (Field field : resultFields) {
      if (!query.contains(field.apiName)) {
        query += field.apiName + ', ';
      }
    }
      
    query += '(SELECT Name FROM ChildAssets WHERE RecordType.DeveloperName = \'Equipement\'), ';
      
    query = query.SubStringBeforeLast(',');

    //FROM
    query += ' FROM Asset';
    System.debug('#query without criteria: ' + query);

    //WHERE
    query += ' WHERE RecordTypeId = \'' + parcRTID + '\'';
    if (!String.isEmpty(criteria)) {
      criteria = criteria.SubStringBeforeLast('AND');
      query += ' AND ' + criteria + '';
    }
      
    System.debug('#criteria : ' + criteria);
    System.debug('#query with criteria: ' + query);

    //ORDER BY / LIMIT
    query += ' ORDER BY Name';
    
    System.debug('##############query : ' + query);
    return Database.query(query);
  }

  @AuraEnabled
  public static List<Asset> getAssetsFSL(List<Field> searchFields, List<Field> resultFields, Id orderId, Asset filter) {
    System.debug('###getAssetsFSL');
    System.debug('#searchFields : ' + searchFields);
    System.debug('#resultFields : ' + resultFields);
    System.debug('#orderId : ' + orderId);
    System.debug('#filter : ' + filter);

    String parcRTID = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Parc_Container').getRecordTypeId();

    //Select
    String query = 'Select Id,  ';
    String criteria = '';

    //Search fields
    Object value;
    Boolean statusDefined = false;
    for (Field field : searchFields) {
      if (!query.contains(field.apiName)) {
        query += field.apiName + ', ';
      }
      if (filter != null) {
        value = filter.get(field.apiName);
        if (
          field.apiName != 'Date_de_debut_asset__c' &&
          field.apiName != 'Date_de_fin_asset__c'
        ) {
          if (value != null && value != '') {
            /* START Exception */
            if (field.apiName == 'Name') {
              criteria += field.apiName + ' = \'' + value + '\' AND ';
            } else if ( field.fieldType == 'PICKLIST' && field.apiName == 'Neuf_ou_parc__c') {
              criteria += '(';
              for (String option : String.valueOf(value).split(';')) {
                criteria += ' Type_de_parc__c = \'' + String.escapeSingleQuotes(option) + '\' OR ';
              }
              criteria = criteria.SubStringBeforeLast('OR');
              criteria += ') AND ';
            } 
              else if (field.apiName == 'Parc__c') {
              criteria += ' Id = \'' + value + '\' AND ';
            } else if (field.apiName == 'Options__c') {
              criteria += '(';
              for (String option : ((String) value).split(';')) {
                criteria += field.apiName + ' LIKE \'%' + String.escapeSingleQuotes(option) + '%\' OR ';
              }
              criteria = criteria.SubStringBeforeLast('OR');
              criteria += ') AND ';
            } else if (field.apiName == 'Status_de_location__c') {
              if (
                filter.get('Date_de_debut_asset__c') == null &&
                filter.get('Date_de_fin_asset__c') == null
              ) {
                criteria += '(';
                for (String option : String.valueOf(value).split(';')) {
                  criteria += field.apiName + ' = \'' + String.escapeSingleQuotes(option) + '\' OR ';
                }
                criteria = criteria.SubStringBeforeLast('OR');
                criteria += ') AND ';
              }
              statusDefined = true;
            } else if (
              field.fieldType == 'String' ||
              field.fieldType == 'TextArea'
            ) {
              /* END Exception */
              criteria += field.apiName + ' LIKE \'%' + value + '%\' AND ';
            } else if (field.fieldType == 'Date') {
              criteria +=
                field.apiName +
                ' = ' +
                ((DateTime) value).format('yyyy-MM-dd') +
                ' AND ';
            } else if (field.fieldType == 'DateTime') {
              criteria +=
                field.apiName +
                ' = ' +
                ((DateTime) value).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'') +
                ' AND ';
            } else if (field.fieldType == 'Time') {
              criteria +=
                field.apiName +
                ' = ' +
                ((DateTime) value).format('\'T\'hh:mm:ss\'z\'') +
                ' AND ';
            } else if (
              field.fieldType == 'Picklist' ||
              field.apiName == 'RecordTypeId'
            ) {
              criteria += '(';
              for (String option : String.valueOf(value).split(';')) {
                criteria += field.apiName + ' = \'' + String.escapeSingleQuotes(option) + '\' OR ';
              }
              criteria = criteria.SubStringBeforeLast('OR');
              criteria += ') AND ';
            } else if (
              field.fieldType == 'Currency' ||
              field.fieldType == 'Percent' ||
              field.fieldType == 'Boolean' ||
              field.fieldType == 'Integer' ||
              field.fieldType == 'Double' ||
              field.fieldType == 'Long'
            ) {
              criteria += field.apiName + ' = ' + value + ' AND ';
            } else {
              criteria += field.apiName + ' = \'' + value + '\' AND ';
            }
          }
        }
      }
    }

    if (filter != null) {
      Object startDate = filter.get('Date_de_debut_asset__c');
      Object endDate = filter.get('Date_de_fin_asset__c');
      if (startDate != null || endDate != null) {
        if (statusDefined && filter.get('Status_de_location__c') != 'Disponible;') {
          criteria += ' Id IN (SELECT Asset_assigne__c FROM Reservation__c ';
          if(startDate != null && endDate != null){
            criteria += 'WHERE (';
            criteria += '(Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(startDate != null){
            criteria += 'WHERE (';
            criteria += 'Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(endDate != null){
            criteria += 'WHERE (';
            criteria += 'Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          if (filter.get('Status_de_location__c') != 'Non disponible;') {
            criteria += ' AND (';
            for (
              String option : ((String) filter.get('Status_de_location__c'))
                .split(';')
            ) {
              criteria +=
                ' RecordType.Name LIKE \'%' +
                option.replace('En ', '') +
                '%\' OR ';
            }
            criteria = criteria.SubStringBeforeLast('OR');
            criteria += ')) AND ';
          } else {
            criteria += ') AND ';
          }
        } 
        else {
          criteria += ' Status_de_location__c != \'Cession\' AND ';
          criteria += ' Id NOT IN (SELECT Asset_assigne__c FROM Reservation__c ';
          if(startDate != null && endDate != null){
            criteria += 'WHERE (';
            criteria += '(Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(startDate != null){
            criteria += 'WHERE (';
            criteria += 'Date_de_debut__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) startDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          else if(endDate != null){
            criteria += 'WHERE (';
            criteria += 'Date_de_fin__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' ';
            criteria += 'OR ';
            criteria += '(Date_de_debut__c <= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ' AND Date_de_fin__c >= ' + ((DateTime) endDate).format('yyyy-MM-dd') + ') ';
            criteria += ')';
          }
          criteria += ') AND ';
        }
      } 
      else if (!statusDefined) {
        criteria += ' Status_de_location__c = \'Disponible\' AND ';
      }
    } else {
      criteria += ' Status_de_location__c = \'Disponible\' AND ';
      //criteria += ' Id NOT IN (SELECT Asset_assigne__c FROM Reservation__c) AND ';
    }

    //Result fields
    for (Field field : resultFields) {
      if (!query.contains(field.apiName)) {
        query += field.apiName + ', ';
      }
    }

    query = query.SubStringBeforeLast(',');

    //FROM
    query += ' FROM Asset';
    System.debug('#query without criteria: ' + query);

    //WHERE
    query += ' WHERE RecordTypeId = \'' + parcRTID + '\'';
    if (!String.isEmpty(criteria)) {
      criteria = criteria.SubStringBeforeLast('AND');
      query += ' AND ' + criteria + '';
    }
    System.debug('#criteria : ' + criteria);
    System.debug('#query with criteria: ' + query);

    //ORDER BY / LIMIT
    // query += ' ORDER BY Name LIMIT 30';

    return Database.query(query);
  }

  /**** PRODUCTS ****/

  @AuraEnabled
  public static List<Product2> getOptionProducts() {
      if(!Test.isRunningTest()){
          return [SELECT Id, Name, ProductCode
                  FROM Product2
                  WHERE Gamme__c LIKE 'Option%' 
                  AND Exclude_For_Container__c = false
                  AND isActive = true
                  ORDER BY Name];
      }
      else{
           return [SELECT Id, Name, ProductCode
                  FROM Product2
                  WHERE Gamme__c LIKE 'Option%'
                  AND Exclude_For_Container__c = false
                  ORDER BY Name];
      }
      
  }

  /**** ORDERS ****/

  @AuraEnabled
  public static Order getOrder(Id orderId) {
    return [SELECT Id, OrderNumber, AccountId, StartDate__c, EndDate__c, Type_de_location__c
            FROM Order
            WHERE Id = :orderId];      
  }

  /************************************* CREATE/UPDATE/DELETE *************************************/

  /*********** RESERVATION - GANTT ***********/

  @AuraEnabled
  public static Reservation__c updateReservationSObjects(EventCalendar eventCalendar, Id assetId) {
    System.debug('updateReservationSObjects - assetId: ' + assetId);
    System.debug('updateReservationSObjects - eventCalendar: ' + eventCalendar);

    Reservation__c reservation = new Reservation__c();
    System.debug('updateReservationSObjects - reservations: ' + reservation);
    reservation.Id = eventCalendar.eventId;
    reservation.Status__c = 'Planifiée';
    reservation.Date_de_debut__c = date.valueof(eventCalendar.Date_de_debut);
    reservation.Date_de_fin__c = date.valueof(eventCalendar.Date_de_fin);
    if (assetId != null) {
      reservation.Asset_assigne__c = assetId;
    }
    update reservation;
    return reservation;
  }

  @AuraEnabled
  public static void scheduleReservations(Id assetId, List<Id> reservationsId) {
    try {
      List<Reservation__c> reservations = new List<Reservation__c>();
      for (Id reservationId : reservationsId) {
        reservations.add(new Reservation__c(Id = reservationId, Asset_assigne__c = assetId, Status__c = 'Planifiée'));
      }
      update reservations;
    } 
    catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }



  /************************************* WRAPPER CLASSES *************************************/

  public class Field {
    @AuraEnabled
    public String apiName { get; set; }
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public String fieldType { get; set; }
    @AuraEnabled
    public Boolean required { get; set; }
    @AuraEnabled
    public Integer length { get; set; }
    @AuraEnabled
    public List<Option> options { get; set; }
    @AuraEnabled
    public Object value { get; set; }
    @AuraEnabled
    public Boolean selected { get; set; }

    public Field(){}

    public Field(
      String apiName,
      String label,
      String fieldType,
      Boolean required,
      Integer length
    ) {
      this.apiName = apiName;
      this.label = label;
      this.fieldType = fieldType;
      this.required = required;
      this.length = length;
      this.selected = false;
    }

    public Field(
      String apiName,
      String label,
      String fieldType,
      Boolean required,
      Integer length,
      List<Option> options
    ) {
      this.apiName = apiName;
      this.label = label;
      this.fieldType = fieldType;
      this.required = required;
      this.length = length;
      this.options = options;
      this.selected = false;
    }
  }

  public class Option {
    @AuraEnabled
    public String value { get; set; }
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public Boolean isDefault { get; set; }

    public Option(){}
    
    public Option(String value, String label) {
      this.value = value;
      this.label = label;
    }

    public Option(String value, String label, Boolean isDefault) {
      this.value = value;
      this.label = label;
      this.isDefault = isDefault;
    }
  }

  public class EventCalendar {
    @AuraEnabled
    public String eventId { get; set; }
    @AuraEnabled
    public String Date_de_debut { get; set; }
    @AuraEnabled
    public String Date_de_fin { get; set; }

    public EventCalendar(){}

    public EventCalendar(
      String eventId,
      String Date_de_debut,
      String fieldType
    ) {
      this.eventId = eventId;
      this.Date_de_debut = Date_de_debut;
      this.Date_de_fin = fieldType;
    }
  }


}
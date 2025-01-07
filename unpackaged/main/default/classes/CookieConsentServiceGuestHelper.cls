public without sharing class CookieConsentServiceGuestHelper {
  /**
   * getIndividualByUserID will get the logged in userId and check to see if an individual has been created
   * @param browserId - the unique browser Id passed from the community
   */
  public static Individual getIndividualByBrowserId(String browserId) {
    List<Individual> individuals = [SELECT Id, BrowserId__c FROM Individual WHERE BrowserId__c = :browserId LIMIT 1];
    Individual individual = (individuals.size() == 1) ? individuals.get(0) : null;
    return individual;
  }

  /**
   * @description - createAuthorizationFormConsentRecords is used to create the consent records that are associated to a positive agreement to cookies.
   * @param individualId - the individualId associated to the user that is accepting the terms
   * @param relatedAuthorizationFormNames - the list of authorization form records that is being used to create the consent records
   */
  public static List<CookieConsent__c> createAuthorizationFormConsentRecords(Id individualId, List<Map<String, String>> cookiePreferences) {
    List<CookieConsent__c> authorizationFormConsentRecords = new List<CookieConsent__c>();
    for (Map<String, String> cookiePreference : cookiePreferences) {
      List<CookieConsentCategory__c> cookieConsentCategories = [
        SELECT Id, Name
        FROM CookieConsentCategory__c
        WHERE Id = :cookiePreference.get('authorizationFormId')
        //WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      CookieConsentCategory__c cookieConsentCategory = (cookieConsentCategories.size() == 1) ? cookieConsentCategories.get(0) : null;
      CookieConsent__c newAuthorizationFormConsentRecord = new CookieConsent__c();
      newAuthorizationFormConsentRecord.Name = cookieConsentCategory.Name;
      newAuthorizationFormConsentRecord.CookieConsentCategory__c = cookieConsentCategory.Id;
      newAuthorizationFormConsentRecord.ConsentCapturedSource__c = 'Salesforce Community';
      newAuthorizationFormConsentRecord.ConsentCapturedSourceType__c = 'Web';
      newAuthorizationFormConsentRecord.ConsentGiverId__c = individualId;
      if (cookiePreference.get('value') == 'true') {
        newAuthorizationFormConsentRecord.Status__c = 'Agreed';
      } else if (cookiePreference.get('value') == 'false') {
        newAuthorizationFormConsentRecord.Status__c = 'Declined';
      }
      authorizationFormConsentRecords.add(newAuthorizationFormConsentRecord);
    }
    insert authorizationFormConsentRecords;
    return authorizationFormConsentRecords;
    /*
    SObjectAccessDecision sanitisedRecords = Security.stripInaccessible(AccessType.CREATABLE, authorizationFormConsentRecords);
    insert sanitisedRecords.getRecords();
    return sanitisedRecords.getRecords();
    */
  }

  /**
   * verifyCookieConsentGranted is called  by verifyCookieConsent if an Individual has been matched to the browserId
   * It gets a list of the available cookie consent definitions, the related authorization form names and then queries a
   * list of valid authorization form consent records that fit those definitions.
   * @param individualId - the individual record associated to the browserId
   */
  public static Boolean verifyCookieConsentGranted(Id individualId) {
    List<CookieConsentCategory__c> cookieConsentCategories = getCookieConsentCategories();
    Set<Id> authFormIds = (new Map<Id, SObject>(cookieConsentCategories)).keySet();
    List<CookieConsent__c> authorizationFormConsents = [
      SELECT Id
      FROM CookieConsent__c
      WHERE CookieConsentCategory__c IN :authFormIds AND ConsentGiverId__c = :individualId
      //WITH SECURITY_ENFORCED
    ];
    if (authorizationFormConsents.size() >= cookieConsentCategories.size()) {
      return true;
    }
    return false;
  }

  /**
   * createIndividualRecord is used to create an individual for a logged in user or browserId
   * @param userId - the userId of the logged in user
   * @param browserId - the unique browser Id passed from the community
   */
  public static Id createIndividualRecord(Id userId, String browserId) {
    List<Individual> newIndividuals = new List<Individual>();
    Individual newIndividual = new Individual(LastName = browserId, BrowserId__c = browserId);
    newIndividuals.add(newIndividual);
    /*
    SObjectAccessDecision sanitisedRecords = Security.stripInaccessible(AccessType.CREATABLE, newIndividuals);
    insert sanitisedRecords.getRecords();
    return sanitisedRecords.getRecords()[0].Id;
    */
    insert newIndividual;
    return newIndividual.Id;
  }

  /**
   * @description - Reusable SOQL Queries Cookie Records
   */
  public static List<CookieConsentCategory__c> getCookieConsentCategories() {
    List<CookieConsentCategory__c> cookieConsentCategories = [
      SELECT DefaultValue__c, Description__c, Manditory__c, AdditionalInformation__c, Id, Name
      FROM CookieConsentCategory__c
      ORDER BY Name
    ];
    return cookieConsentCategories;
  }

  public static List<Cookie__c> getRelatedCookies(Id cookieConsentCategoryId) {
    List<Cookie__c> relatedCookies = [SELECT Description__c, Id, Name FROM Cookie__c WHERE CookieConsentCategory__c = :cookieConsentCategoryId];
    return relatedCookies;
  }

  /**
   * getIndividualByUserID will get the logged in userId and check to see if an individual has been created
   * @param userId - the userId of the logged in user
   */
  public static User getLoggedInUserDetails(Id userId) {
    List<User> users = [SELECT FirstName, LastName, IndividualId FROM User WHERE Id = :userId LIMIT 1];
    User user = (users.size() == 1) ? users.get(0) : null;
    return user;
  }

  /**
   * @description - Get cookies from the user if they've been rejected by the person accessing the community.
   * @param browserId - the unique browser Id passed from the community
   * @return List<String> of Cookies
   */
  @AuraEnabled
  public static List<String> getCookiesToDelete(String browserId) {
    Set<Id> categoryIds = new Set<Id>();
    for (CookieConsent__c consent : [
      SELECT CookieConsentCategory__c
      FROM CookieConsent__c
      WHERE ConsentGiverId__c IN (SELECT Id FROM Individual WHERE BrowserId__c = :browserId) AND Status__c = 'Declined'
    ]) {
      categoryIds.add(consent.CookieConsentCategory__c);
    }

    List<String> cookieNames = new List<String>();
    for (Cookie__c cookie : [SELECT Id, Name FROM Cookie__c WHERE CookieConsentCategory__c IN :categoryIds]) {
      cookieNames.add(cookie.Name);
    }
    return cookieNames;
  }

  /**
   * createCookieConsentRecords is used to confirm authorization for cookie consent against the browserId
   * @param browserId - the unique browser Id passed from the community
   */
  @AuraEnabled
  public static boolean createCookieConsentRecords(String browserId, List<Map<String, String>> cookiePreferences) 
  {
    Individual individual = CookieConsentServiceGuestHelper.getIndividualByBrowserId(browserId);
    List<CookieConsent__c> createdConsentRecords = CookieConsentServiceGuestHelper.createAuthorizationFormConsentRecords(individual.Id, cookiePreferences);
    if (createdConsentRecords != null) 
    {
      return true;
    }
    return false;
  }

  /**
   * verifyCookieConsentGranted is called  by verifyCookieConsent if an Individual has been matched to the browserId
   * It gets a list of the available cookie consent definitions, the related authorization form names and then queries a
   * list of valid authorization form consent records that fit those definitions.
   * @param individualId - the individual record associated to the browserId
   */
  @AuraEnabled
  public static List<Map<String, Object>> getCookieConsentGranted(String browserId) 
  {
    Individual individual = CookieConsentServiceGuestHelper.getIndividualByBrowserId(browserId);
    List<CookieConsent__c> authorizationFormConsents = new List<CookieConsent__c>();
    List<AggregateResult> CookieConsentRecordsSize = new List<AggregateResult>();
    if (individual != null) 
    {
      Id individualId = individual.Id;
      List<CookieConsentCategory__c> cookieConsentCategories = getCookieConsentCategories();
      Set<Id> authFormIds = (new Map<Id, SObject>(cookieConsentCategories)).keySet();
      CookieConsentRecordsSize =  
      [
        SELECT Name
        FROM CookieConsent__c
        WHERE CookieConsentCategory__c IN :authFormIds AND ConsentGiverId__c = :individualId GROUP BY Name
        //WITH SECURITY_ENFORCED
      ];
      authorizationFormConsents = 
      [
        SELECT Id, Name, Status__c, ConsentGiverId__c, CookieConsentCategory__c, CookieConsentCategory__r.Description__c, CookieConsentCategory__r.AdditionalInformation__c, CookieConsentCategory__r.Manditory__c,  createddate
        FROM CookieConsent__c
        WHERE CookieConsentCategory__c IN :authFormIds AND ConsentGiverId__c = :individualId ORDER BY createddate DESC limit :CookieConsentRecordsSize.size()
        //WITH SECURITY_ENFORCED
      ];
    }
  
    List<Map<String, Object>> finalCookieData = new List<Map<String, Object>>();
    for (CookieConsent__c authorizationFormConsent : authorizationFormConsents) 
    {
      List<Cookie__c> relatedCookies = CookieConsentServiceGuestHelper.getRelatedCookies(authorizationFormConsent.CookieConsentCategory__c);
      Map<String, Object> sectionItem = new Map<String, Object>();
      sectionItem.put('SectionName', authorizationFormConsent.Name);
      sectionItem.put('SectionDescription', authorizationFormConsent.CookieConsentCategory__r.Description__c);
      sectionItem.put('CookieConsentCategory', authorizationFormConsent.CookieConsentCategory__c);
      sectionItem.put('ConsentGiverId', authorizationFormConsent.ConsentGiverId__c);
      sectionItem.put('RelatedAuthorizationFormId', authorizationFormConsent.Id);
      sectionItem.put('Mandatory', authorizationFormConsent.CookieConsentCategory__r.Manditory__c);
      sectionItem.put('DefaultValue', true);
      sectionItem.put('AdditionalInformation', authorizationFormConsent.CookieConsentCategory__r.AdditionalInformation__c);
      sectionItem.put('SectionCookies', relatedCookies);

      if(authorizationFormConsent.Status__c == 'Agreed')
      {
        sectionItem.put('Status', true);
      }
      else if (authorizationFormConsent.Status__c != 'Agreed' )
      {
        sectionItem.put('Status', false);
      }
      if (finalCookieData.isEmpty()) {
        //sectionItem.put('ShowSection', true);
        //sectionItem.put('SectionIcon', 'utility:chevrondown');

        sectionItem.put('ShowSection', false);
        sectionItem.put('SectionIcon', 'utility:chevronright');
      } else {
        sectionItem.put('ShowSection', false);
        sectionItem.put('SectionIcon', 'utility:chevronright');
      }
      finalCookieData.add(sectionItem);
    }
    return finalCookieData;
  }

  /*   ************* GFC-1373 ************* 
  *   Edited by : Hicham El Achboura
  *   Date : 25/01/2023
  *   Comment : This Component is used to edit cookie consent records from Community visitors and give them control over their autorisations. 
  */
  @AuraEnabled
  //public static List<CookieConsent__c> updateCookieConsentGranted(List<String>  AuthorizationFormIdList, List<CookieConsent__c> AuthorizationFormRecList) 
  public static List<CookieConsent__c> updateCookieConsentGranted(List<CookieConsent__c> AuthorizationFormRecList) 
  {    
    String Response;
    try 
    {
      update AuthorizationFormRecList;
      Response = 'SUCCESS';  
      return AuthorizationFormRecList;
    }
    catch(DmlException e )
    {
      Response = e.getMessage();
      return AuthorizationFormRecList;
    }
  }

  /*   ************* GFC-1373 ************* 
  *   Comment : This Component is used to insert cookie consent records from Community visitors and give them control over their autorisations. 
  */
  @AuraEnabled
  public static String insertCookieConsentGranted(CookieConsent__c  CookieConsentList) 
  {    
    String Response = 'SUCCESS';
    try 
    {    
      insert CookieConsentList;
      return Response;
    }
    catch(Exception e )
    {
      Response = e.getMessage();
      return Response ;
    }
  }

}
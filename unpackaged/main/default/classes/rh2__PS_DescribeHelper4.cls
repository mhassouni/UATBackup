/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global interface PS_DescribeHelper4 {
    Integer countQuery(String param0);
    Object get(String param0, SObject param1);
    Database.QueryLocator getQueryLocator(String param0, Map<String,Object> param1);
    Map<String,Schema.DescribeFieldResult> getThisAllFieldsDescribe(String param0);
    Schema.DescribeFieldResult getThisFieldDescribe(Schema.ChildRelationship param0);
    Schema.DescribeFieldResult getThisFieldDescribe(String param0, Schema.SObjectField param1);
    Schema.DescribeFieldResult getThisFieldDescribe(String param0, String param1);
    String getThisFieldLabel(String param0, String param1);
    String getThisFieldType(String param0, String param1);
    Schema.DescribeSObjectResult getThisObjectDescribe(Schema.SObjectType param0);
    Schema.DescribeSObjectResult getThisObjectDescribe(String param0);
    String getThisObjectLabel(String param0);
    SObject getThisPrototypeObject(String param0);
    Boolean isThisObjectIdThisType(Id param0, String param1);
    List<SObject> query(String param0);
    List<SObject> query(String param0, Map<String,Object> param1);
}

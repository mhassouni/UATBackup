/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class GetFieldInformation {
    global GetFieldInformation() {

    }
    global static List<usf.FieldDescriptor> describeSObject(String type) {
        return null;
    }
    global static Map<String,List<usf.FieldDescriptor>> describeSObjects(List<String> types) {
        return null;
    }
    global static Map<String,usf.FieldDescriptor> describeSObjects(String obj) {
        return null;
    }
    @InvocableMethod
    global static List<usf.GetFieldInformation.Results> getFieldInformation(List<usf.GetFieldInformation.Requests> requestList) {
        return null;
    }
global class Requests {
    @InvocableVariable( required=true)
    global String objectName;
    global Requests() {

    }
}
global class Results {
    @InvocableVariable( required=false)
    global List<usf.FieldDescriptor> fields;
    global Results() {

    }
}
}

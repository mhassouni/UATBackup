/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class LiveGetClosestRecordInvocable {
    global LiveGetClosestRecordInvocable() {

    }
    @InvocableMethod(label='Get Closet Record for a Given Stop Record')
    global static List<maps.LiveGetClosestRecordInvocable.getClosestRecordResponse> getClosestRecord(List<maps.LiveGetClosestRecordInvocable.getClosestRecordRequest> requestList) {
        return null;
    }
global class getClosestRecordRequest {
    @InvocableVariable(label='GeoLocation API Name' required=true)
    global String latLongGeoFieldApiName;
    @InvocableVariable(label='Object API Name' required=true)
    global String queryObjApiName;
    @InvocableVariable(label='Summary Event Record Id' required=true)
    global Id sumEventId;
    global getClosestRecordRequest() {

    }
}
global class getClosestRecordResponse {
    @InvocableVariable(label='Distance in Kilometers' required=false)
    global Decimal distanceKM;
    @InvocableVariable(label='Distance in Miles' required=false)
    global Decimal distanceMiles;
    @InvocableVariable(label='Record Id (Null if no records are found)' required=false)
    global Id objId;
    global getClosestRecordResponse() {

    }
}
}

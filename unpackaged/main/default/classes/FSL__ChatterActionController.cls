/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class ChatterActionController {
    @RemoteAction
    global static void ChangeServiceToBeforeFormState(FSL.ChatterActionController.ServiceAppointmentChatter InputService, FSL.ChatterActionController.ChatterActionAdditionalData AdditionalData) {

    }
    @RemoteAction
    global static FSL.ChatterActionController.ServiceCreationResult CreateOrUpdateService(FSL.ChatterActionController.ServiceAppointmentChatter InputService, FSL.ChatterActionController.ChatterActionAdditionalData AdditionalData) {
        return null;
    }
    @RemoteAction
    global static FSL.ChatterActionController.ChatterActionFirstStageResult DoFirstStage(FSL.ChatterActionController.ServiceAppointmentChatter InputService, Boolean IsSLR, String ApexInterfaceFullName, FSL.ChatterActionController.ChatterActionAdditionalData AdditionalData) {
        return null;
    }
    @RemoteAction
    global static FSL.ChatterActionController.ChatterActionSecondStageResult DoSecondStage(FSL.ChatterActionController.ServiceAppointmentChatter InputService, Boolean IsSLR, String ApexInterfaceFullName, FSL.ChatterActionController.ChatterActionAdditionalData AdditionalData) {
        return null;
    }
    @RemoteAction
    global static FSL.ChatterActionController.ChatterActionData getChatterActionData(Id ObjectId) {
        return null;
    }
    @RemoteAction
    global static List<FSL.ChatterActionController.ServiceTerritoryChatter> searchTerritories(String text) {
        return null;
    }
    @RemoteAction
    global static void updatePermissionSets() {

    }
    @RemoteAction
    global static Map<String,String> updatePermissionSetsWithTabAndRecordTypeReturned() {
        return null;
    }
global class ChatterActionAdditionalData {
    global ChatterActionAdditionalData() {

    }
}
global class ChatterActionData {
}
global class ChatterActionFirstStageResult extends FSL.ChatterActionController.ChatterActionStageResult {
    global ChatterActionFirstStageResult() {

    }
}
global class ChatterActionSecondStageResult extends FSL.ChatterActionController.ChatterActionStageResult {
    global ChatterActionSecondStageResult() {

    }
}
global abstract class ChatterActionStageResult {
    global ChatterActionStageResult() {

    }
}
global class ServiceAppointmentChatter {
    global ServiceAppointmentChatter() {

    }
}
global class ServiceCreationResult {
    global ServiceCreationResult() {

    }
}
global class ServiceTerritoryChatter {
    global ServiceTerritoryChatter() {

    }
}
}

/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
@RestResource(urlMapping='/dc3Job/*')
global class dc3JobExternal {
    global dc3JobExternal() {

    }
    @HttpDelete
    global static void deleteJob() {

    }
    @HttpGet
    global static void getJobList() {

    }
    @HttpPut
    global static void setJobStatus(Id jobId, String status) {

    }
    @HttpPost
    global static Boolean setResult(dupcheck.dc3JobExternal.ResultInput input) {
        return null;
    }
global class ExternalField {
    global String fieldLabel {
        get;
        set;
    }
    global String fieldName {
        get;
        set;
    }
    global String fieldType {
        get;
        set;
    }
    global ExternalField(String n, String l, String t) {

    }
}
global class ExternalJob {
    global String autoProcess {
        get;
        set;
    }
    global Boolean cloudJob {
        get;
        set;
    }
    global Map<String,String> crossFieldMap {
        get;
        set;
    }
    global Integer duplicateCount {
        get;
        set;
    }
    global String filterType {
        get;
        set;
    }
    global Boolean hierarchyEnabled {
        get;
        set;
    }
    global Boolean indexEmailDomain {
        get;
        set;
    }
    global dupcheck.dc3JobExternal.IndexJobData indexJobData {
        get;
        set;
    }
    global Boolean isCrossObject {
        get;
        set;
    }
    global Boolean isRecordType {
        get;
        set;
    }
    global Id jobId {
        get;
        set;
    }
    global String jobName {
        get;
        set;
    }
    global String jobType {
        get;
        set;
    }
    global Integer licenseLimit {
        get;
        set;
    }
    global String match {
        get;
        set;
    }
    global List<dupcheck.dc3JobExternal.ExternalField> matchFields {
        get;
        set;
    }
    global String matchFilter {
        get;
        set;
    }
    global String matchLabel {
        get;
        set;
    }
    global String matchObject {
        get;
        set;
    }
    global String matchQuery {
        get;
        set;
    }
    global List<dupcheck.dc3JobExternal.ExternalResultField> matchResultFields {
        get;
        set;
    }
    global Integer mergeThreshold {
        get;
        set;
    }
    global String objectFilterField {
        get;
        set;
    }
    global String objectFilterType {
        get;
        set;
    }
    global String objectFilterValue {
        get;
        set;
    }
    global String ownerEmailAddress {
        get;
        set;
    }
    global Id ownerId {
        get;
        set;
    }
    global String ownerName {
        get;
        set;
    }
    global Id parentJobId {
        get;
        set;
    }
    global String parentJobName {
        get;
        set;
    }
    global Integer recordCount {
        get;
        set;
    }
    global Map<Id,dupcheck.dc3JobExternal.ExternalRecordTypeConfig> recordTypeConfig {
        get;
        set;
    }
    global List<dupcheck.dc3JobExternal.ExternalScenario> scenarioList {
        get;
        set;
    }
    global String source {
        get;
        set;
    }
    global List<dupcheck.dc3JobExternal.ExternalField> sourceFields {
        get;
        set;
    }
    global String sourceFilter {
        get;
        set;
    }
    global String sourceLabel {
        get;
        set;
    }
    global String sourceObject {
        get;
        set;
    }
    global String sourceQuery {
        get;
        set;
    }
    global List<dupcheck.dc3JobExternal.ExternalResultField> sourceResultFields {
        get;
        set;
    }
    global Datetime startDate {
        get;
        set;
    }
    global String status {
        get;
        set;
    }
    global String statusLabel {
        get;
        set;
    }
    global ExternalJob() {

    }
}
global class ExternalRecordTypeConfig {
    global Boolean master {
        get;
        set;
    }
    global Set<Id> matchWith {
        get;
        set;
    }
    global Id recordTypeId {
        get;
        set;
    }
    global Set<Id> scenarios {
        get;
        set;
    }
    global ExternalRecordTypeConfig() {

    }
}
global class ExternalResultField {
    global String fieldLabel {
        get;
        set;
    }
    global String fieldName {
        get;
        set;
    }
    global Integer order {
        get;
        set;
    }
    global ExternalResultField(dupcheck.dc3Config.ResultField rf) {

    }
    global ExternalResultField(String name, String label, Integer order) {

    }
}
global class ExternalScenario {
    global List<dupcheck.dc3JobExternal.ExternalScenarioField> fieldList {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String scenarioId {
        get;
        set;
    }
    global String scoreMethod {
        get;
        set;
    }
    global Integer threshold {
        get;
        set;
    }
    global ExternalScenario() {

    }
}
global class ExternalScenarioField {
    global Boolean doNotIndex {
        get;
        set;
    }
    global String field {
        get;
        set;
    }
    global String frequentList {
        get;
        set;
    }
    global List<String> groupIndex;
    global String matchConfig {
        get;
        set;
    }
    global String matchMethod {
        get;
        set;
    }
    global String synonymList {
        get;
        set;
    }
    global Integer weight {
        get;
        set;
    }
    global ExternalScenarioField() {

    }
}
global class GroupPair {
    global Integer groupNumber;
    global Id matchId;
    global Integer score;
    global Id sourceId;
    global GroupPair() {

    }
}
global class IndexJobData {
    global String indexField {
        get;
        set;
    }
    global String indexObjectName {
        get;
        set;
    }
    global String indexObjectType {
        get;
        set;
    }
    global String objectPrefix {
        get;
        set;
    }
    global String objectPrefixField {
        get;
        set;
    }
    global Boolean personAccount {
        get;
        set;
    }
    global String personAccountField {
        get;
        set;
    }
    global String recordIdField {
        get;
        set;
    }
    global String recordTypeField {
        get;
        set;
    }
    global IndexJobData() {

    }
}
global class JobListResult {
    @Deprecated
    global Set<String> dicardItems;
    global Map<String,Set<String>> frequentWords {
        get;
        set;
    }
    global List<dupcheck.dc3JobExternal.ExternalJob> jobList {
        get;
        set;
    }
    global Integer pageEnd {
        get;
        set;
    }
    global Integer pageNumber {
        get;
        set;
    }
    global Integer pageStart {
        get;
        set;
    }
    global Integer recordLimit {
        get;
        set;
    }
    global Map<String,List<List<String>>> synonymLists {
        get;
        set;
    }
    global Integer totalCount {
        get;
        set;
    }
    global JobListResult() {

    }
    global Blob toBlob() {
        return null;
    }
}
global class ResultInput {
    global Boolean finished;
    global Id jobId;
    global List<dupcheck.dc3JobExternal.GroupPair> result;
    global ResultInput() {

    }
}
}

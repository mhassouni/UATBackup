global class RetrieveRequestedGradeScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        System.debug('Retrieve requested grade batch scheduler start');

        // Process all contracts ending today
        RetrieveRequestedGradeBatch retrieveRequestedGradeBatch = new RetrieveRequestedGradeBatch();
        Database.executeBatch(retrieveRequestedGradeBatch);
    }
}
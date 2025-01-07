global class UpdateAncestorsBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        UpdateAncestorsBatch batchJob = new UpdateAncestorsBatch();
        Database.executeBatch(batchJob, 100);
    }
}
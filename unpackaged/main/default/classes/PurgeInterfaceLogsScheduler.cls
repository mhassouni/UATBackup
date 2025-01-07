global class PurgeInterfaceLogsScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Schedule the batch job for chain 1
        PurgeInterfaceLogsBatch batchJob = new PurgeInterfaceLogsBatch(1, false);
        Database.executeBatch(batchJob, 200);
    }
}
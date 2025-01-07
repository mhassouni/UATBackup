global class BatchVCCAgrementScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        System.debug('VCC agrement batch scheduler start');

        // Process all contracts ending today
        BatchVCCAgrement VCCAgrementBatch = new BatchVCCAgrement();
        Database.executeBatch(VCCAgrementBatch);
    }
}
public class PF_UsageProcessorScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        PF_UsageProcessor up = new PF_UsageProcessor();
        Database.executeBatch(up);
    }
}
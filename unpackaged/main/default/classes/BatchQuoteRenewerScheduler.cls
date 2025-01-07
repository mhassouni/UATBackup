/**
 * Created by 4C on 04/03/2022.
 */

global class BatchQuoteRenewerScheduler implements Schedulable {

    global void execute(SchedulableContext ctx) {
        System.debug('Quote renewer batch scheduler start');

        // Process all contracts ending today
        BatchQuoteRenewerProcessor qr = new BatchQuoteRenewerProcessor(Date.today());
        Database.executeBatch(qr, 100);
    }
}
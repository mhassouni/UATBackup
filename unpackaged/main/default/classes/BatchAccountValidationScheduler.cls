global class BatchAccountValidationScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        System.debug('Check account grade batch scheduler start');

        BatchAccountValidation BatchAccountValidation = new BatchAccountValidation();
        Database.executeBatch(BatchAccountValidation);

        BatchAccountValidationScheduler.start();
    }

    public static void start()
        {
            // start keepalive again in 5 mins
            Datetime sysTime = System.now().addSeconds( 300 );      
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            System.schedule( 'BatchAccountValidationScheduler ' + sysTime, chronExpression, new BatchAccountValidationScheduler() );
        }
}
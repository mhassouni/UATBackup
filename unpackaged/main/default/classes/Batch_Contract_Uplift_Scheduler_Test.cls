@istest

public class Batch_Contract_Uplift_Scheduler_Test {
    static testmethod void test() {
   Test.startTest();

      // Schedule the test job

      String jobId = System.schedule('testBasicScheduledApex',
      '0 0 5 1 * ? *', 
         new Batch_Contract_Uplift_Scheduler());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals('0 0 5 1 * ? *', 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

   Test.stopTest();

   

   }
}
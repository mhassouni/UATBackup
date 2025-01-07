/**
* @Version: 1.0
* @Author: Remz Grges
* @Uses: 
* -----------------------------------------------------------------------------------------------
* Description: 
* Created: 27/08/2021
** -----------------------------------------------------------------------------------------------
*/
@IsTest
public with sharing class PF_UsageProcessorSchedulerTest {

    @IsTest
    static void testSchedule() {
        Long curMilis = System.currentTimeMillis();
        Test.startTest();
           String schedule = System.schedule('PF_UsageProcessorScheduler Job ' + curMilis, '0 0 * * * ?', new PF_UsageProcessorScheduler());
        Test.stopTest();
        System.debug(schedule);
        System.assertNotEquals(null, schedule);
    }
}
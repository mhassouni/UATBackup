/**
 * Created by 4C on 17/03/2022.
 */

public with sharing class InvocablePF_UsageProcessor {

    @InvocableMethod(Label='Unique order usage process' Description='Launch usage process on a unique order')
    public static void UsageProcessorUniqueOrder(List<List<Order>> orderId) {
        PF_UsageProcessor pf = new PF_UsageProcessor(orderId.get(0).get(0).Id);
        Database.executeBatch(pf,50);
    }

}
public class GeographicFootprintBatch_TriggerHandler 
{
    @InvocableMethod(label='Trigger GeographicFootprint Batch')
    public static void triggerGeographicFootprintBatch() 
    {
        GeographicFootprint_Batch batch = new GeographicFootprint_Batch();
        Database.executeBatch(batch, 100);
    }
}
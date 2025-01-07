public class InvokeCaseAssignmentRules
{
    @InvocableMethod
    public static void caseAssgnmntRules(List<Id> caseIds)
    {
            Database.DMLOptions dmlOption = new Database.DMLOptions();
            dmlOption.assignmentRuleHeader.useDefaultRule= true;          
            Case caseCreated= new Case();
            caseCreated = [select id from Case where id in :caseIds];
            caseCreated.setOptions(dmlOption);
            update caseCreated;
   }
}
@isTest
public class InvokeCaseAssignmentRules_Test 
{
	@isTest
    private static void invokeCaseAssignmentRuleTest()
    {
		Case CaseRecord = new Case();
        CaseRecord.status = 'Nouvelle';  // old value
        insert CaseRecord;
        List<Id> caseIds = new List<Id>();
        caseIds.add(CaseRecord.id);
        InvokeCaseAssignmentRules.caseAssgnmntRules(caseIds);        
    }
}
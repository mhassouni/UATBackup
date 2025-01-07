/**
 * Created by 4C on 07/04/2022.
 */

global class BatchQuoteRenewerTestAction {

    @InvocableMethod(Label='Test Batch Renew contract' Description='Launch batch renew contract test')
    public static void testBatchQuoteRenewerUnitary(List<List<Contract>> contracts) {
        BatchQuoteRenewerPreprocessor prep = new BatchQuoteRenewerPreprocessor(
                contracts.get(0).get(0).Id,
                contracts.get(0).get(0).ContractNumber,
                UserInfo.getUserId()
        );
        Database.executeBatch(prep);
    }
}
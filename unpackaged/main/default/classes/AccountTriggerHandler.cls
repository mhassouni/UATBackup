public with sharing class AccountTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean isFirstRun = TRUE;

    public AccountTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeUpdate( List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap , Map<ID, Account> oldAccountMap ) {
        system.debug('Account Trigger On Before Update ');
        AccountActions.updateContact (newAccount, oldAccount, newAccountMap, oldAccountMap);
    }
}
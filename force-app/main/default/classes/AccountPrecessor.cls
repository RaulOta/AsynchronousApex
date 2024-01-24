public with sharing class AccountPrecessor {

    @future()
    public static void countContacts(List<Id> accountIds) {
        List<Account> accounts = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds];

        for (Account acc : accountIds) {
            acc.Number_Of_Employees__c = acc.Contacts.size();
            //System.debug('Number of employes', acc.Contacts.size());
        }

        update accounts;
    }
}
@isTest
public with sharing class AddPrimaryContactTest {
    @isTest
    private static void validaAddPrimaryContactForSmallAccounts(){
        // Load test data
        List<Account> accs = new List<Account>();
        for(Integer a = 0; a < 100; a++){

            Account acc = new Account(Name='Test NY ' + a);
            if (a < 50){
                acc.BillingState = 'NY';
            }else {
                acc.BillingState = 'CA';
            }
            accs.add(acc);
        }
        insert accs;

        Contact ct = new Contact(FirstName= 'Simon', LastName = 'Connok');
        insert ct;

        // Perform test
        Test.startTest();
        System.enqueueJob(new AddPrimaryContact(ct, 'CA'));
        Test.stopTest();

        // Check the result
        List<Contact> act = [SELECT Id FROM Contact WHERE Contact.Account.BillingState = 'CA'];
        System.assertEquals(50, act.size(), 'Error Test');
    }

    @isTest
    private static void validaAddPrimaryContactForBigAccountsWithLimitQuery(){

        //Load test data
        List<Account> lstAcounts = new List<Account>();
        for(Integer a = 0; a < 500; a++){
            Account account = new Account(Name='Test NY ' + a);
            if (a < 250) {
                account.BillingState = 'NY';
            }else {
                account.BillingState = 'CA';
            }
            lstAcounts.add(account);
        }
        insert lstAcounts;

        Contact contact = new Contact(FirstName='Raul', LastName='Montiel');
        insert contact;

        //Perform test
        AddPrimaryContact context = new AddPrimaryContact(contact, 'NY');
        Test.startTest();
        System.enqueueJob(context);
        Test.stopTest();

        //Check the result
        List<Contact> lstContact = [SELECT Id FROM Contact WHERE Contact.Account.BillingState = 'NY'];
        System.assertEquals(200, lstContact.size(), 'The limit in the SOQL query is not correct');
    }

    @isTest
    private static void validaAddPrimaryContactForExceptionAccounts(){

        //Load test data
        List<Account> lstAcounts = new List<Account>();
        for(Integer a = 0; a < 500; a++){
            Account account = new Account(Name='Test NY ' + a);
            if (a < 250) {
                account.BillingState = 'NY';
            }else {
                account.BillingState = 'CA';
            }
            lstAcounts.add(account);
        }
        insert lstAcounts;

        Contact contact = new Contact(FirstName='Raul', LastName='Montiel');
        insert contact;

        //Perform test
        AddPrimaryContact context = new AddPrimaryContact(contact, '');
        try {
            Test.startTest();
            System.enqueueJob(context);
            Test.stopTest();
            /* Siempre colocar al final de la invocación del método una assert que falle en 
            caso de que alguien borre la invocación de la excepción, si no se coloca siempre va a 
            marcar correcto como esta dentro del try catch nunca va a entrar, ya con el assert nos damos cuenta si se modifico. */
            System.assert(false, 'The method did not throw an exception');
            
        } catch (Exception e) {
            System.assert(e.getMessage().contains('the state will not null'), e.getMessage());
        }
    }
}
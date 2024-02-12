public class AddPrimaryContact implements Queueable {

    /* Custom Exceptions
    https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_exception_custom.htm */
    public class AddPrimaryContactException extends Exception {}

    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact record, string state) {
        this.contact = record;
        this.state = state;
    }

    public void execute(QueueableContext contex)
    {
        // Awesome processing logic here
        List<Account> accts = [SELECT Id FROM Account WHERE BillingState =:state LIMIT 200];

        List<Contact> contacts = new List<Contact>();

        if (String.isEmpty(state)) 
            throw new AddPrimaryContactException('the state will not null');

        for (Account acct : accts) {
        Contact contactClone = contact.clone();
        contactClone.AccountId = acct.Id;
        contacts.add(contactClone);
        }
        insert contacts;

        // Chain this job to next job by submitting the next job
        // Sysytem.enqueueJob(new secondJob());
    }
}
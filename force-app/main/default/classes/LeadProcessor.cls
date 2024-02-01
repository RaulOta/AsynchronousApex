public with sharing class LeadProcessor implements Database.Batchable<SObject> {

    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT ID, Name FROM Lead');
    }

    public void execute(Database.BatchableContext bc, List<Lead> leads){
        //Process each bath of records/leads
        for(Lead lead : leads){
            lead.LeadSource = 'Dreamforce';
            recordsProcessed = recordsProcessed + 1;
        }

        update leads;
    }

    public void finish(Database.BatchableContext bc){
        //Execute any post-processing operations
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob
        WHERE Id = :bc.getJobId()];
        // Call some utility to send email

    }
}
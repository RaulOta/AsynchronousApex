@isTest
private class LeadProcessorTest {
    @isTest
    private static void testBatchClass(){
        //Load test Data
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0; i < 200; i++){
            leads.add(new Lead(LastName = 'Test '+i, Company = 'Salesforce' ) );
        }
        insert leads;
    
        // Perform the test
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp, 200);
        Test.stopTest();

        // Check the result
        List<Lead> updatedLeads = [SELECT Id FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size(), 'Great!!');
        // System.assertEquals(100, [SELECT COUNT() FROM Lead WHERE LeadSource = 'DreamSource'], 'Great!!');
    }
}
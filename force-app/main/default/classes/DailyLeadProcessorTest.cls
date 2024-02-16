@isTest
public with sharing class DailyLeadProcessorTest {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';

    @isTest
    static void testScheduledJob() {

        // Load test data
        List<Lead> lstLoads = new List<Lead>();
        for(Integer a = 0; a < 500; a++){
            lstLoads.add(new Lead(FirstName = 'Raúl', LastName='Test'+a, LeadSource = 'blank', Company = 'Salesforce'));
        }
        insert lstLoads;

        // Perform test
        Test.startTest();
        /* Schedule the test job */
        String jobId = System.schedule('ScheduleApexTraildhead', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest();

        // Check the result
        lstLoads = [SELECT id FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, lstLoads.size(), 'The results is not equals');
    }
}
public class DailyLeadProcessor implements Schedulable {
    public void execute( SchedulableContext contexSchedule) {
        List<Lead> lstLeads = [SELECT Id FROM Lead WHERE LeadSource = 'blank' LIMIT 200];

        UpdateLeadTask.updateLead(lstLeads);
    }
}
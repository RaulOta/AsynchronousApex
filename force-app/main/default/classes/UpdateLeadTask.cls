public with sharing class UpdateLeadTask {
    
    public static void updateLead(List<Lead> lstLeads){
        for(Lead lead : lstLeads){
            lead.LeadSource = 'Dreamforce';
        }
        update lstLeads;
    }
}
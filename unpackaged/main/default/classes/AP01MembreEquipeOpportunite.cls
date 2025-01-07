/*
* OPP-RG-004: Lorsque la « date clôture prévue » d’une opportunité est dépassée sans que son statut soit passé à « Opportunité Gagnée » ou « Contrat Signé », une notification par Chatter est envoyée au propriétaire.
* OPP-RG-005: Si la "date clôture appel d'offre" est renseignée, sa valeur est reprise automatiquement dans la "date clôture effective" de l'opportunité.
* N.B. Si la "date clôture appel d'offre" est vidée par la suite, la "date clôture effective" est vidée aussi.
* @Author Ali Naji
* @TestClass AP01MembreEquipeOpportunite_TEST
* @CodeCoverage 100%
*/
public class AP01MembreEquipeOpportunite {

	public static void SendChatterNotif(List<OpportunityTeamMember> members, boolean Operation)
	{
		set<String> OpportunityIDs = new set<String>();
		for (OpportunityTeamMember otm : members)
		{
			OpportunityIDs.add(otm.OpportunityId);
		}
		
		Map<String,Opportunity> Combinations = new Map<String,Opportunity>([SELECT Name, Account.Name, Owner.Name, TECHLienSF__c
																			FROM Opportunity
																			WHERE Id in: OpportunityIDs]);
		
		for (OpportunityTeamMember otm : members)
		{
			//if (!Test.isRunningTest())
			
				if (Operation)
				{
					ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, otm.UserId, ConnectApi.FeedElementType.FeedItem, Label.OPP_OpportunityTeamMemberAdded_ChatterNotifPart1+' '+Combinations.get(otm.OpportunityId).Name+' '+ Label.OPP_OpportunityTeamMemberAdded_ChatterNotifPart2+' ' +Combinations.get(otm.OpportunityId).Account.Name+'. ('+string.valueof(System.TODAY())+') \n' + Label.OPP_OpportunityTeamMemberAdded_ChatterNotifPart3+' ' +Combinations.get(otm.OpportunityId).TECHLienSF__c+'.');
				}
				else
				{
					ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, otm.UserId, ConnectApi.FeedElementType.FeedItem, Label.OPP_OpportunityTeamMemberRemoved_ChatterNotifPart1+' '+Combinations.get(otm.OpportunityId).Name +' '+ Label.OPP_OpportunityTeamMemberRemoved_ChatterNotifPart2+' ' +Combinations.get(otm.OpportunityId).Account.Name+'. ('+string.valueof(System.TODAY())+') \n' + Label.OPP_OpportunityTeamMemberRemoved_ChatterNotifPart3 +' '+Combinations.get(otm.OpportunityId).Owner.Name+'.');
				}
			
		}
	}

}
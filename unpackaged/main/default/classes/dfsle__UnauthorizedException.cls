/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class UnauthorizedException extends Exception {
    global dfsle.UnauthorizedException.AccessRequirement requirement {
        get;
    }
    global Id userId {
        get;
    }
global enum AccessRequirement {AccountMember, ClmAdministrator, ClmCommunityUser, ClmUser, ClmViewer, ConfigureAccount, CurrentSalesforceUser, DocuSignAdministrator, DocuSignBillingAdmin, DocuSignGenerator, DocuSignLogin, DocuSignNegotiator, DocuSignSender, DocuSignUser, EnvelopeOwner, IntegrationUser, OriginalUser, SalesforceAdministrator, SecurityPermission, Unspecified}
}

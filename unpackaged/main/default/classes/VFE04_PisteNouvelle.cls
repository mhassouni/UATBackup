public with sharing class VFE04_PisteNouvelle{

    public VFE04_PisteNouvelle(ApexPages.StandardController controller) {
        
    }
    
    public PageReference Redirects()
    {
        PageReference pageRef = new PageReference('/'+Label.PST_Records_Id+'/e?nooverride=1&'+Label.PST_Company_Id+'='+Label.PST_Name_Sighting+'&'+Label.PST_LastName_Id+'='+Label.PST_Name_Sighting+'&retURL='+Label.PST_CreateNew_RetURL);
        pageRef.setRedirect(true);
                return pageRef;
    }

}
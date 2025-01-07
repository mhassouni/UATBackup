public class Utils_Methods {
    
  
    //Determine if this is SF1 app
    public static Boolean isSF1(){
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
            String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
            ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
            (ApexPages.currentPage().getParameters().get('retURL') != null && 
            ApexPages.currentPage().getParameters().get('retURL').contains('projectone')))
        {
            return true;
        }else {
            return false;
        }
    }
}
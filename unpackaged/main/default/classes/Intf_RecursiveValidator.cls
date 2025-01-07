/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/

global class Intf_RecursiveValidator {
    private static boolean alreadyDone = false;

    public static boolean isAlreadyDone(){ 
        return alreadyDone;
    }

    public static void setAlreadyDone() {  
        alreadyDone = true;
    }
}
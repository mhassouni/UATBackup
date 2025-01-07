/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/

public without sharing class Intf_GenerallntService {

    
    /**
    * Generates a unique Message Id for every HTTP callout made to SAP
    * @return   The unique message Id
    */
    public static String getUMessageId() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8) + h.SubString(8,12) + h.SubString(12,16) + h.SubString(16,20);

        System.debug('## Unique Message Id: ' + guid);
        return guid;
    }


//TODO Integration PF bypass information
//    public static boolean checkByPassCurrentUser(){
//        System.debug('============== Method bypassCurrentUser: Start ');
//
//        String usersLabel  = System.Label.Intf_MDW_BYPASS_USERS;
//        List<String> listUsers = usersLabel.split(',');
//        System.debug('============== Method bypassCurrentUser: listUsers '+listUsers);
//        if (listUsers !=null)
//            for (String user : listUsers){
//                System.debug('============== Method bypassCurrentUser: Check User '+user);
//                if (UserInfo.getName() == user){
//                    System.debug('============== Method bypassCurrentUser: bypass user '+user);
//                    return true;
//                }
//            }
//        System.debug('============== Method bypassCurrentUser: End without bypass');
//        return false;
//    }

}
/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_ServiceResult {

    public Boolean isSuccess {get; set;}
    public string body {get; set;}
    public String errorType {get; set;}
    public Integer statusCode {get; set;}

    public Intf_ServiceResult(string body, Integer statusCode) {
        this.body = body;
        this.isSuccess = body != null;
        this.statusCode = statusCode;
    }

}
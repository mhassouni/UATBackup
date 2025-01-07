/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_RequestInput {

    public String urlString {get; set;}
    public String method  { get; set; }
    public Map<String, String> headers  { get; set; }
    public String parameters  { get; set; }
    public String encoding {get; set;}
    public Integer timeout = 30000;

    private Map<String, String> defaultHeaders {

        get { return new Map<String, String> {'Content-Type' => 'text/xml;charset=UTF-8'}; }//'Content-Type', 'text/xml; charset=character encoding'
    }

    public Intf_RequestInput(String urlString, String method, String parameters) {
        this.urlString = urlString;
        this.method = method;
        this.parameters = parameters;
        this.headers =  this.defaultHeaders;
    }
    
    // Edited by Hicham El Achboura
    // Ticket GFC-2137 -- GFC-2138
    public Intf_RequestInput(String urlString, String method, String parameters, Map<String, String> headers) {
        this.urlString = urlString;
        this.method = method;
        this.parameters = parameters;
        this.headers = headers;
    }


}
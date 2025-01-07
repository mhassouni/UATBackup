public class FoliateamCTI_SearchParam {

    public String entityName;
    public List<Properties> properties;

    public class Properties {
        public String displayName;
        public String apiName;
    }

    
    public static List<FoliateamCTI_SearchParam> parse(String json) {
        return (List<FoliateamCTI_SearchParam>) System.JSON.deserialize(json, List<FoliateamCTI_SearchParam>.class);
    }
}
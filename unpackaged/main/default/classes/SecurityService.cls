public class SecurityService { 
   public static final String ALG = 'alg'; 
   public static final String SUB = 'sub'; 
   public static final String ISS = 'iss'; 
   public static final String AUD = 'aud'; 
   public static final String NBF = 'nbf'; 
   public static final String EXP = 'exp'; 
   public static final String HS256 = 'HS256'; 
   public static final String TYP = 'typ'; 
   public static final String JWT = 'JWT'; 
   public static final String DOT = '.'; 
   public static final String HMACSHA256 = 'HmacSHA256'; 
   private static Long jwtExpirationDate; 
 
 
   public static String generateJWT(String algorithm, String userName, String issuer, String audience, Integer expiryInMinutes, String signature) { 
       String encodedHeader = encodeHeader(algorithm); 
       String encodedBody = encodeBody(userName, issuer, audience, expiryInMinutes); 
       String jwt = encodedHeader + DOT + encodedBody; 
       if (algorithm == HS256) { 
           Blob blobSignature = Crypto.generateMac(HMACSHA256, Blob.valueOf(jwt), Blob.valueOf(signature)); 
           String encodedSignature = base64UrlEncode(blobSignature); 
           jwt += DOT + encodedSignature; 
       } 
       return jwt; 
   } 
 
 
   private static String encodeHeader(String algorithm) { 
       JSONGenerator header = JSON.createGenerator(false); 
       header.writeStartObject(); 
       header.writeStringField(ALG, algorithm); 
       if (algorithm == HS256) { 
           header.writeStringField(TYP, JWT); 
       } 
       header.writeEndObject(); 
       Blob blobHeader = Blob.valueOf(header.getAsString()); 
       return base64UrlEncode(blobHeader); 
   } 
 
 
   private static String encodeBody(String userName, String issuer, String audience, Integer expiryInMinutes) { 
       JSONGenerator body = JSON.createGenerator(false); 
       body.writeStartObject(); 
       body.writeStringField(SUB, userName); 
       body.writeStringField(ISS, issuer); 
       body.writeStringField(AUD, audience); 
       Datetime timeNow = Datetime.now(); 
       body.writeNumberField(NBF, timeNow.getTime()/1000); 
       if (jwtExpirationDate == null) { 
           jwtExpirationDate = timeNow.addMinutes(expiryInMinutes).getTime()/1000; 
       } 
       body.writeNumberField(EXP, jwtExpirationDate); 
       body.writeEndObject(); 
       Blob blobBody = Blob.valueOf(body.getAsString()); 
       return base64UrlEncode(blobBody); 
   } 
 
 
   public static String base64UrlEncode(Blob input){ 
       String output = EncodingUtil.base64Encode(input); 
       output = output.replace('+', '-'); 
       output = output.replace('/', '_'); 
       while ( output.endsWith('=')){ 
           output = output.substring(0,output.length()-1); 
       } 
       return output; 
   } 
}
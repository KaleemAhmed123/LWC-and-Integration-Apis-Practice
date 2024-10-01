global class ApiErrorHandler {
     global static void setError(Integer code, String message) {
        RestResponse res = RestContext.response;
        res.statusCode = code;
        res.responseBody = Blob.valueOf(JSON.serialize(new ResponseWrapper('Failed', message)));
    }
    
    public class ResponseWrapper {
        public String message;
        public String status;
        public ResponseWrapper(String status, String message) {
            this.message = message;
            this.status = status;
        }
    }
}
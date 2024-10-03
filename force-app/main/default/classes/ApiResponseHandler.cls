global class ApiResponseHandler {
  global static void setResponse(Integer code, Object response) {
    RestResponse res = RestContext.response;
    res.statusCode = code;

    if (response instanceof String) {
      res.responseBody = Blob.valueOf(
        JSON.serialize(new MessageWrapper((String) response))
      );
    } else if (response instanceof List<Object>) {
      res.responseBody = Blob.valueOf(
        JSON.serialize(new ListWrapper((List<Object>) response))
      );
    } else {
      res.responseBody = Blob.valueOf(
        JSON.serialize(new ObjectWrapper(response))
      );
    }
  }

  public class MessageWrapper {
    public String message;
    public MessageWrapper(String message) {
      this.message = message;
    }
  }

  public class ObjectWrapper {
    public Object data;
    public ObjectWrapper(Object data) {
      this.data = data;
    }
  }

  public class ListWrapper {
    public List<Object> dataList;
    public ListWrapper(List<Object> dataList) {
      this.dataList = dataList;
    }
  }
}

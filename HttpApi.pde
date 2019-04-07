import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.FileEntity;
import org.apache.http.HttpEntity;
import org.apache.http.util.EntityUtils;

class HttpApi {

    public int getRandomSeed() {
      int randonSeed = 0;
      org.apache.http.client.HttpClient httpClient = HttpClientBuilder.create().build(); //Use this instead 
  
      try {
          println("Requesting Static from random.org");
          HttpPost request = new HttpPost("https://api.random.org/json-rpc/2/invoke");
          FileEntity params = new FileEntity( new File ( dataPath("randomPost.json") ) );
          request.addHeader("content-type", "application/json");
          request.setEntity(params);
          org.apache.http.HttpResponse response = httpClient.execute(request);
          org.apache.http.HttpEntity entity = response.getEntity();
          String responseJson = EntityUtils.toString(entity);
          
          println(responseJson);
          
          processing.data.JSONObject json = processing.data.JSONObject.parse(responseJson.replaceAll("[\\[\\]()]",""));

          randonSeed = json.getJSONObject("result").getJSONObject("random").getInt("data");

      } catch (Exception ex) {
          println(ex);
      }
      
      return randonSeed; 
    }

}

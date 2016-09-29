import twitter4j.conf.*;
import twitter4j.api.*;
import twitter4j.*;
import java.io.*;

class Twitter {
  
  ConfigurationBuilder cb;
  twitter4j.Twitter twitter;
  String configFile = dataPath("config.json");
  processing.data.JSONObject jsonConfig;
  public Twitter() {
    jsonConfig = loadJSONObject( configFile );
    
    cb = getConfiguration();
    twitter = new TwitterFactory(cb.build()).getInstance();
  }
  
  public void postTweet(String seedType, String fileExtension) {
    try {
      
      if (!jsonConfig.isNull("nextFile")) {
      
        
        String nextFileName = jsonConfig.getString("nextFile");
        String nextSeed = jsonConfig.getString("nextSeed");
        
        File imageFile = new File( dataPath("img/" + nextFileName) );
        if (imageFile.exists()) {

          InputStream inputStream = new FileInputStream(imageFile);
          StatusUpdate status = new StatusUpdate(String.valueOf( nextSeed ));
          status.setMedia(nextSeed + fileExtension, inputStream);
          twitter.updateStatus(status);
          
          println("Successfully updated the status");
          
        } else {
          println("No file found to upload");
        }
        
      }
      
      setNextImage(seedType, fileExtension);
      
    } catch (Exception te) {
      
      te.printStackTrace();
      println("Failed to update status: " + te.getMessage());
      
    }
  }
  
  private ConfigurationBuilder getConfiguration() {
    ConfigurationBuilder config = new ConfigurationBuilder();

    config.setOAuthConsumerKey( jsonConfig.getString("ConsumerKey") );
    config.setOAuthConsumerSecret( jsonConfig.getString("ConsumerSecret") );
    config.setOAuthAccessToken( jsonConfig.getString("AccessToken") );
    config.setOAuthAccessTokenSecret( jsonConfig.getString("AccessTokenSecret") );
    
    return config;
  }
  
  private void setNextImage(String seedType, String fileName) {
    jsonConfig.setString("nextSeed", seedType);
    jsonConfig.setString("nextFile", seedType + fileName);
    
    saveJSONObject(jsonConfig, configFile);
  }
  
}
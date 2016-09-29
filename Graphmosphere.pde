/*
  Graphmosphere
*/
import gifAnimation.*;

GifMaker gifExport;
int frames = 0;
int totalFrames = 57;
float step = 0;

String seedType = "";
int seed = 0;
Formula formula;
Vector vector;
Twitter twitter;

// The statements in the setup() function 
// execute once when the program begins
void setup() {
  
  //String[] args = new String[1]; args[0] = "data/99454584.json";
  if (args != null && args.length != 0) {
    
    String jsonFile = args[0]; 
    this.formula = new Formula(loadJSONObject( jsonFile ));
    
  } else {
    
    getSeed();
    this.formula = new Formula(this.seed, this.seedType);
    
    // Save json for backup  
    processing.data.JSONObject json = formula.getJson();
    saveJSONObject(json, dataPath("json/"+formula.getSeedType()+".json"));
    
  }

  // Initial setup
  size(720, 720, P3D);  // Size must be the first statement
  smooth(100);
  frameRate(60);
  noFill();
  strokeWeight(4);
  loop();
  
  vector = new Vector(formula, width, height);
  twitter = new Twitter();
  
  if (formula.animation != Enum.Animation.Static) {
    gifExport = new GifMaker(this, dataPath("img/"+formula.getSeedType()+".gif"), 100);
    gifExport.setRepeat(0); // make it an "endless" animation
  }
    
  translate(0, 0, -(width + height) / 10);
}

// The statements in draw() are executed until the 
// program is stopped. Each statement is executed in 
// sequence and after the last line is read, the first 
// line is executed again.
void draw() {
  doDraw();
  export();
}

void doDraw() {
  // Darken #1d1d1d
  background(1907997);
  
  vector.animate();
  int[][] myVector = vector.getVector();

  stroke(255);
  
  for (int i = 0; i < myVector.length; i++) {
    int 
      x1, y1, z1, curve1, colorR1, colorG1, colorB1,
      x2, y2, z2, curve2;
    
    x1 = myVector[i][Enum.VectorColumns.X.getValue()];
    y1 = myVector[i][Enum.VectorColumns.Y.getValue()];
    z1 = myVector[i][Enum.VectorColumns.Z.getValue()];
    curve1 = myVector[i][Enum.VectorColumns.Curve.getValue()];
    colorR1 = myVector[i][Enum.VectorColumns.ColorR.getValue()];
    colorG1 = myVector[i][Enum.VectorColumns.ColorG.getValue()];
    colorB1 = myVector[i][Enum.VectorColumns.ColorB.getValue()];
    
    x2 = myVector[vector.getNextVector(i)][Enum.VectorColumns.X.getValue()];
    y2 = myVector[vector.getNextVector(i)][Enum.VectorColumns.Y.getValue()];
    z2 = myVector[vector.getNextVector(i)][Enum.VectorColumns.Z.getValue()];
    curve2 = myVector[vector.getNextVector(i)][Enum.VectorColumns.Curve.getValue()];
    
    stroke(colorR1, colorG1, colorB1);
    curve(x1 + curve1, y1 + curve1, x1, y1, x2, y2, x2 + curve2, y2 + curve2);
    
    stroke(colorR1, colorG1, colorB1);
    curve(x1 + curve1, y1 + curve1, z1, x1, y1, z1, x2, y2, z2, x2 + curve2, y2 + curve2, z2);
    
    stroke(colorR1, colorG1, colorB1);
    int[] vortexCoords = vector.getDimensionCoord(x1, y1);
    line(x1, y1, 0, vortexCoords[0], vortexCoords[1], z1);
  }
}

void export() {
  if (formula.animation == Enum.Animation.Static) {
    save(dataPath("img/"+formula.getSeedType()+".png"));
    println(formula.getSeedType() + " png saved");
    tweet();
    exit();
  } else {
    if(frames < totalFrames) {
      gifExport.setDelay(20);
      gifExport.addFrame();
      frames++;
    } else {
      gifExport.finish();
      frames++;
      println(formula.getSeedType() + " gif saved");
      tweet();
      exit();
    }
  }
}

void tweet() {
  String fileExtension = (formula.animation != Enum.Animation.Static) ? ".gif" : ".png";
  this.twitter.postTweet(formula.getSeedType(), fileExtension);
}

void screenDebug() {
  stroke(255);
  text(formula.getString(), 50, 50);
  text(vector.getString(), 150, 50);
}

void getSeed() {
  
  this.seed = (int) random(99999999);
  this.seedType = "j";
  
  try {
    
    int atmosphericSeed = new HttpApi().getRandomSeed();
    if (atmosphericSeed != 0) {
      println("Atmospheric seeded.");
      this.seed = atmosphericSeed;
      this.seedType = "r";
    }
    
  } catch (Exception e){
    println(e);
  }
}
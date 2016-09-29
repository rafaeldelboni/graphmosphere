
class Formula {
  /*
    Variations:
    * Color
      + 0: BW (60%)
      + 1: Partial Color (20%)
      + 2: Full Color (20%)
    * Shapes
      + 0: Closed (75%)
      + 1: Open (25%)
    * Symmetric
      + 0: No (50%)
      + 1: YesX (25%)
      + 2: YesY (25%)
    * Dimensions
      + 0: 2D (35%)
      + 1: 3D Single Depth (35%)
      + 2: 3D Multiple Depth (10%)
      + 3: 3D Vortex (20%)
    * Vectors
      + Quantity
        = 0: S (3 - 8) (40%)
        = 1: M (8 - 16) (50%)
        = 2: L (16 - 32) (10%)
      + Types
        = 0: Lines (40%)
        = 1: Lines & Curves (40%)
        = 2: Curves (20%)
    * Animation
      + 0: Static (65%)
      + 1: Movement (20%)
      + 2: Multi Movement (15%)
        = Speed
          - 0: Slow (33%)
          - 1: Medium (33%)
          - 2: Fast (34%)
        = Types
          - 0: Horizontal (25%)
          - 1: Vertical (25%)
          - 2: Rotation (50%)
            -- 3: X (15%)
            -- 4: Y (15%)
            -- 5: Z (20%)
  */
  private int seed;
  private String seedType;
  private String dateCreated;
  private Enum.Color colors;
  private Enum.Shapes shape;
  private Enum.Symmetric symmetric;
  private Enum.Dimension dimension;
  private Enum.VectorQuantities quantity;
  private Enum.VectorTypes types;
  private Enum.Animation animation;
  private AnimationMovements[] animationMovements;
  
  public Formula (int seed, String seedType) {
    randomSeed(seed);
    
    this.seed = seed;
    this.seedType = seedType;
    this.dateCreated = String.valueOf( System.currentTimeMillis() );
    this.colors = generateColor();
    this.shape = generateShape();
    this.symmetric = generateSymmetric();
    this.dimension = generateDimension();
    this.quantity = generateVectorQuantity();
    this.types = generateVectorTypes();
    this.animation = generateAnimation();
    
    if (this.animation.getValue() > 0) {
      
      animationMovements = new AnimationMovements[this.animation.getValue()];
      
      for (int i = 0; i < this.animation.getValue(); i++) {
        
        animationMovements[i] = new AnimationMovements( //<>// //<>// //<>//
          generateAnimationSpeed(), 
          generateAnimationType()
        );
         //<>// //<>// //<>//
      }
      
    }
    
  }
  
  public Formula (processing.data.JSONObject jsonSeed) {
    
    this.seed = jsonSeed.getInt("seed");
    this.seedType = jsonSeed.getString("seedType");
    this.dateCreated = jsonSeed.getString("dateCreated");
    this.colors = Enum.Color.values()[jsonSeed.getInt("colors")];
    this.shape = Enum.Shapes.values()[jsonSeed.getInt("shape")];
    this.symmetric = Enum.Symmetric.values()[jsonSeed.getInt("symmetric")];
    this.dimension = Enum.Dimension.values()[jsonSeed.getInt("dimension")];
    this.quantity = Enum.VectorQuantities.values()[jsonSeed.getInt("quantity")];
    this.types = Enum.VectorTypes.values()[jsonSeed.getInt("types")];
    this.animation = Enum.Animation.values()[jsonSeed.getInt("animation")];
    
    if (this.animation.getValue() > 0) {
      
      processing.data.JSONArray animationTypesValues = jsonSeed.getJSONArray("animationMovements");
      animationMovements = new AnimationMovements[this.animation.getValue()];
      
      for (int i = 0; i < this.animation.getValue(); i++) {
        
        processing.data.JSONObject animationTypesObj = animationTypesValues.getJSONObject(i);
        
        animationMovements[i] = new AnimationMovements(
          Enum.AnimationSpeed.values()[animationTypesObj.getInt("speed")],
          Enum.AnimationTypes.values()[animationTypesObj.getInt("type")]
        );
        
      }
    
    }
    
  }
  
  public processing.data.JSONObject getJson() {
    processing.data.JSONObject json = new processing.data.JSONObject();

    json.setInt("seed", this.seed);
    json.setString("seedType", this.seedType);
    json.setString("dateCreated", this.dateCreated);
    json.setInt("colors", this.colors.getValue());
    json.setInt("shape", this.shape.getValue());
    json.setInt("symmetric", this.symmetric.getValue());
    json.setInt("dimension", this.dimension.getValue());
    json.setInt("quantity", this.quantity.getValue());
    json.setInt("types", this.types.getValue());
    json.setInt("animation", this.animation.getValue());
    
    if (this.animation.getValue() > 0) {
      
      processing.data.JSONArray animationTypes = new processing.data.JSONArray();
      
      for (int i = 0; i < this.animation.getValue(); i++) {
        
        processing.data.JSONObject animationInfo = new processing.data.JSONObject();
        
        animationInfo.setInt("speed", this.animationMovements[i].getSpeedValue());
        animationInfo.setInt("type", this.animationMovements[i].getTypesValue());
        
        animationTypes.setJSONObject(i, animationInfo);
        
      }
      
      json.setJSONArray("animationMovements", animationTypes);
    }
    
    return json;
  }
  
  public String getString() {
    String text = "";
    
    text += "seed: " + String.valueOf( this.seed ) + "\n";
    text += "seed: " + String.valueOf( this.seedType ) + "\n";
    text += "dateCreated: " + String.valueOf( this.dateCreated ) + "\n";
    text += "color: " + String.valueOf( this.colors )  + "\n";
    text += "shape: " + String.valueOf( this.shape ) + "\n";
    text += "symmetric: " + String.valueOf( this.symmetric ) + "\n";
    text += "dimension: " + String.valueOf( this.dimension ) + "\n";
    text += "quantity: " + String.valueOf( this.quantity ) + "\n";
    text += "types: " + String.valueOf( this.types ) + "\n";
    text += "animation: " + String.valueOf( this.animation ) + "\n";
    
    if (this.animation.getValue() > 0) {
      
      for (int i = 0; i < this.animation.getValue(); i++) {
        
        text += "speed: " + String.valueOf( this.animationMovements[i].getSpeed() ) + "\n";
        text += "type: " + String.valueOf( this.animationMovements[i].getTypes() ) + "\n";
        
      }
      
    }
    
    return text;
  }
  
  public int getSeed() {
    return this.seed;
  }
  
  public String getSeedType() {
    return this.seed + this.seedType;
  }
  
  private Enum.Color generateColor() {
    Enum.Color colorOpt;
    int rand = (int) random(100);
    
    if (rand < 60) {
      // 60% chance
      colorOpt = Enum.Color.BW;
    } else if (rand < 80) {
      // 20% chance
      colorOpt = Enum.Color.PartialColor;
    } else {
      // 20% chance
      colorOpt = Enum.Color.FullColor;
    }  
     
    return colorOpt;
  }
  
  private Enum.Shapes generateShape() {
    Enum.Shapes shapeOpt; 
    int rand = (int) random(100);
    
    if (rand < 75) {
      // 75% chance
      shapeOpt = Enum.Shapes.Closed;
    } else {
      // 25% chance
      shapeOpt = Enum.Shapes.Open;
    }
    return shapeOpt;
  }
  
  private Enum.Symmetric generateSymmetric() {
    Enum.Symmetric symmetricOpt;
    int rand = (int) random(100);
    
    if (rand < 50) {
      // 50% chance
      symmetricOpt = Enum.Symmetric.No;
    } else if (rand < 75) {
      // 25% chance
      symmetricOpt = Enum.Symmetric.YesX;
    } else {
      // 25% chance
      symmetricOpt = Enum.Symmetric.YesY;
    }
    return symmetricOpt;
  }
  
  private Enum.Dimension generateDimension() {
    Enum.Dimension dimensionOpt;
    int rand = (int) random(100);
    
    if (rand < 35) {
      // 35% chance
      dimensionOpt = Enum.Dimension.d2D;
    } else if (rand < 70) {
      // 35% chance
      dimensionOpt = Enum.Dimension.d3DSingleDepth;
    } else if (rand < 80) {
      // 10% chance
      dimensionOpt = Enum.Dimension.d3DMultipleDepth;
    } else {
      // 20% chance
      dimensionOpt = Enum.Dimension.d3DVortex;
    }
  
    return dimensionOpt;
  }
  
  private Enum.VectorQuantities generateVectorQuantity() {
    Enum.VectorQuantities vQtdOpt;
    int rand = (int) random(100);
    
    if (rand < 40) {
      // 40% chance
      vQtdOpt = Enum.VectorQuantities.Small;
    } else if (rand < 90) {
      // 50% chance
      vQtdOpt = Enum.VectorQuantities.Medium;
    } else {
      // 10% chance
      vQtdOpt = Enum.VectorQuantities.Large;
    }
    return vQtdOpt;
  }
  
  private Enum.VectorTypes generateVectorTypes() {
    Enum.VectorTypes typesOpt;
    int rand = (int) random(100);
    
    if (rand < 40) {
      // 40% chance
      typesOpt = Enum.VectorTypes.Lines;
    } else if (rand < 80) {
      // 40% chance
      typesOpt = Enum.VectorTypes.LinesCurves;
    } else {
      // 20% chance
      typesOpt = Enum.VectorTypes.Curves;
    }  
     
    return typesOpt;
  }
  
  private Enum.Animation generateAnimation() {
    Enum.Animation animOpt;
    int rand = (int) random(100);
    
    if (rand < 65) {
      // 65% chance
      animOpt = Enum.Animation.Static;
    } else if (rand < 85) {
      // 20% chance
      animOpt = Enum.Animation.Movement;
    } else {
      // 15% chance
      animOpt = Enum.Animation.MultiMovement;
    }
    
    return animOpt;
  }
  
  private Enum.AnimationSpeed generateAnimationSpeed() {
    Enum.AnimationSpeed animOpt;
    int rand = (int) random(100);
    
    if (rand < 33) {
      // 33% chance
      animOpt = Enum.AnimationSpeed.Slow;
    } else if (rand < 66) {
      // 33% chance
      animOpt = Enum.AnimationSpeed.Medium;
    } else {
      // 34% chance
      animOpt = Enum.AnimationSpeed.Fast;
    }

    return animOpt;
  }
  
  private Enum.AnimationTypes generateAnimationType() {
    Enum.AnimationTypes animOpt;
    int rand = (int) random(100);
    
    if (rand < 25) {
      // 25% chance
      animOpt = Enum.AnimationTypes.Horizontal;
    } else if (rand < 50) {
      // 25% chance
      animOpt = Enum.AnimationTypes.Vertical;
    } else if (rand < 65) {
      // 15% chance
      animOpt = Enum.AnimationTypes.RotationX;
    } else if (rand < 80) {
      // 15% chance
      animOpt = Enum.AnimationTypes.RotationY;
    } else {
      // 20% chance
      animOpt = Enum.AnimationTypes.RotationZ;
    }
    
    return animOpt;
  }
    
}
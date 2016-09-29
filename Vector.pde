class Vector {
  
  Formula formula;
  int actualWidth, actualHeight;
  int[][] vector;
  
  public Vector (Formula formula, int width, int height) {
    this.formula = formula;
    this.actualWidth = width;
    this.actualHeight = height;
    this.vector = generateVector(width, height);
  }
  
  public int [][] getVector() {
    return this.vector;
  }
  
  public String getString() {
    String text = "vector:\n";
    
    for (int i = 0; i < this.vector.length; i++) {
      text += "i: " + String.valueOf( i ) + "\n";
      text += "x: " + String.valueOf( this.vector[i][Enum.VectorColumns.X.getValue()] ) + "\n";
      text += "y: " + String.valueOf( this.vector[i][Enum.VectorColumns.Y.getValue()] ) + "\n";
      text += "z: " + String.valueOf( this.vector[i][Enum.VectorColumns.Z.getValue()] ) + "\n";
      text += "curve: " + String.valueOf( this.vector[i][Enum.VectorColumns.Curve.getValue()] ) + "\n";
      text += "color r: " + String.valueOf( this.vector[i][Enum.VectorColumns.ColorR.getValue()] ) + "\n";
      text += "color g: " + String.valueOf( this.vector[i][Enum.VectorColumns.ColorG.getValue()] ) + "\n";
      text += "color b: " + String.valueOf( this.vector[i][Enum.VectorColumns.ColorB.getValue()] ) + "\n";
    }
    
    return text;
  }
   //<>// //<>// //<>// //<>// //<>//
  public int[] getDimensionCoord(int x, int y) {
    randomSeed(formula.getSeed());
    
    int[] dimensionCoord = new int[2];
    int vortex = (int) random(0, (this.actualWidth + this.actualHeight) / 2);
    
    if (formula.dimension == Enum.Dimension.d3DVortex) {
      dimensionCoord[0] = vortex;
      dimensionCoord[1] = vortex;
    } else {
      dimensionCoord[0] = x;
      dimensionCoord[1] = y;
    }
    
    return dimensionCoord;
  }
  
  public int getNextVector(int actualVector) {
    int nextVector;
    
    if (actualVector != vector.length-1) {
      nextVector = actualVector + 1;
    } else {
      if(formula.shape == Enum.Shapes.Closed) {
        nextVector = 0;
      } else {
        nextVector = actualVector;
      }
    }
    
    return nextVector;
  }
  float step = 0;
  int direction = 1;
  public float animate() {

    if (formula.animation != Enum.Animation.Static) { 
      float speed = calculateAnimationSpeed(formula.animationMovements[0]);
      
      if (step > 15 && direction > 0)
        direction = -1;
  
      if (step < -15 && direction < 0)
        direction = 1;
      
      step = step + (1 * direction) * speed;
      
      for (int i = 0; i < formula.animation.getValue(); i++) {
        
        calculateAnimationTypes(formula.animationMovements[i], step);
        
      }
      
    }
    
    return step;
  }
  
  private int[][] generateVector(int width, int height) {
    randomSeed(formula.getSeed());
    
    int vectorsQtd = calculateVectorQuantity();
    
    if (formula.symmetric != Enum.Symmetric.No && vectorsQtd % 2 != 0) {
      vectorsQtd++;
    }
      
    int[][] generatedVector = new int[vectorsQtd][Enum.VectorColumns.values().length];
    int zDepth = calculateZDepth();

    int symmetricNegative = vectorsQtd/2;
    
    color fullColor = calculateColor();

    for (int i = 0; i < vectorsQtd; i++) {
      if (formula.symmetric == Enum.Symmetric.No) {
        generatedVector[i][Enum.VectorColumns.X.getValue()] = (int) random(width/8, width-(width/8));
        generatedVector[i][Enum.VectorColumns.Y.getValue()] = (int) random(height/8, height-(height/8));
        generatedVector[i][Enum.VectorColumns.Z.getValue()] = (formula.dimension == Enum.Dimension.d3DMultipleDepth) ? calculateZDepth() : zDepth;
        generatedVector[i][Enum.VectorColumns.Curve.getValue()] = calculateVectorTypes();
      } else {
        if (i+1 <= vectorsQtd/2) {
          if (formula.symmetric == Enum.Symmetric.YesX) {
            generatedVector[i][Enum.VectorColumns.X.getValue()] = (int) random(width/8, width-(width/2));
            generatedVector[i][Enum.VectorColumns.Y.getValue()] = (int) random(height/8, height-(height/8));
          } else {
            generatedVector[i][Enum.VectorColumns.X.getValue()] = (int) random(width/8, width-(width/8));
            generatedVector[i][Enum.VectorColumns.Y.getValue()] = (int) random(height/8, height-(height/2));
          }
          generatedVector[i][Enum.VectorColumns.Z.getValue()] = (formula.dimension == Enum.Dimension.d3DMultipleDepth) ? calculateZDepth() : zDepth;
          generatedVector[i][Enum.VectorColumns.Curve.getValue()] = calculateVectorTypes();
        } else {
          int mirrorX = generatedVector[i-symmetricNegative][Enum.VectorColumns.X.getValue()];
          int mirrorY = generatedVector[i-symmetricNegative][Enum.VectorColumns.Y.getValue()];
          int differenceX = (width/2) - mirrorX;
          int differenceY = (height/2) - mirrorY;
          
          if (formula.symmetric == Enum.Symmetric.YesX) {
            generatedVector[i][Enum.VectorColumns.X.getValue()] = differenceX + width/2;
            generatedVector[i][Enum.VectorColumns.Y.getValue()] = generatedVector[i-symmetricNegative][Enum.VectorColumns.Y.getValue()];
          } else {
            generatedVector[i][Enum.VectorColumns.X.getValue()] = generatedVector[i-symmetricNegative][Enum.VectorColumns.X.getValue()];
            generatedVector[i][Enum.VectorColumns.Y.getValue()] = differenceY + height/2;
          }

          generatedVector[i][Enum.VectorColumns.Z.getValue()] = generatedVector[i-symmetricNegative][Enum.VectorColumns.Z.getValue()];
          generatedVector[i][Enum.VectorColumns.Curve.getValue()] = generatedVector[i-symmetricNegative][Enum.VectorColumns.Curve.getValue()];
        }
      }
      
      
      color c = (formula.colors == Enum.Color.FullColor) ? fullColor : calculateColor(); 

      generatedVector[i][Enum.VectorColumns.ColorR.getValue()] = (int)red(c);
      generatedVector[i][Enum.VectorColumns.ColorG.getValue()] = (int)green(c);
      generatedVector[i][Enum.VectorColumns.ColorB.getValue()] = (int)blue(c);
    }
    
    return generatedVector;
  }
  
  private int calculateVectorQuantity() {
    int vectorsQtd;
    
    switch(formula.quantity) {
    case Small: 
      vectorsQtd = (int) random(3, 8);
      break;
    case Medium: 
      vectorsQtd = (int) random(8, 16);
      break;
    case Large: 
      vectorsQtd = (int) random(16, 32);
      break;
    default: 
      vectorsQtd = (int) random(8, 16);
      break;
    }
    
    return vectorsQtd;
  }
  
  private int calculateZDepth() {
    int vectorsZDepth;
  
    switch(formula.dimension) {
    case d2D: 
      vectorsZDepth = 0;
      break;
    case d3DSingleDepth: 
      vectorsZDepth = (int) random(0, 250);
      break;
    case d3DMultipleDepth: 
      vectorsZDepth = (int) random(0, 250);
      break;
    case d3DVortex: 
      vectorsZDepth = (int) random(0, 250);
      break;
    default: 
      vectorsZDepth = 0;
      break;
    }
    
    return vectorsZDepth;
  }
  
  private int calculateVectorTypes() {
    int vectorsTypes;
  
    switch(formula.types) {
    case Lines: 
      vectorsTypes = 0;
      break;
    case LinesCurves: 
      vectorsTypes = (random(1) < .5) ? (int) random(0, 250) : 0;
      break;
    case Curves: 
      vectorsTypes = (int) random(0, 250);
      break;
    default: 
      vectorsTypes = 0;
      break;
    }
    
    return vectorsTypes;
  }
  
  private color calculateColor() {
    color vectorColor;
    
    int r = (int) random(0, 255), g = (int) random(0, 255), b = (int) random(0, 255);
    
    switch(formula.colors) {
    case BW: 
      vectorColor = color(255,255,255);
      break;
    case PartialColor: 
      vectorColor = color(r,g,b);
      break;
    case FullColor: 
      vectorColor = color(r,g,b);
      break;
    default: 
      vectorColor = color(255,255,255);
      break;
    }
    
    return vectorColor;
  }
  
  private void calculateAnimationTypes(AnimationMovements animMov, float step) {
    switch(animMov.getTypes()) {
    case Horizontal: 
      translate(step, 0);
      break;
    case Vertical: 
      translate(0, step);
      break;
    case RotationX: 
      rotateX(radians(step));
      break;
    case RotationY: 
      rotateY(radians(step));
      break;
    case RotationZ: 
      rotateZ(radians(step));
      break;
    default: 
      break;
    }
  }
  
  private float calculateAnimationSpeed(AnimationMovements animMov) {
    float speed = 0;
    if (animMov == null) {
      speed = 0;
    } else {
      switch(animMov.getSpeed()) {
        case Slow:
          speed = 1;
          break;
        case Medium:
          speed = 2.5;
          break;
        case Fast:
          speed = 5;
          break;
        default:
          speed = 0;
          break;
      }
    }
    return speed;
  }
}
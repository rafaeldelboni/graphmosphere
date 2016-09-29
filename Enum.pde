static class Enum {
  
  static enum Color
  {
    BW(0), 
    PartialColor(1), 
    FullColor(2);
      
    private final int value;
    private Color(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum Shapes
  {
    Closed(0), 
    Open(1);
      
    private final int value;
    private Shapes(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum Symmetric
  {
    No(0), 
    YesX(1),
    YesY(2);
    
    private final int value;
    private Symmetric(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum Dimension
  {
    d2D(0), 
    d3DSingleDepth(1),
    d3DMultipleDepth(2),
    d3DVortex(3);
    
    private final int value;
    private Dimension(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum VectorQuantities
  {
    Small(0), 
    Medium(1),
    Large(2);
    
    private final int value;
    private VectorQuantities(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum VectorTypes
  {
    Lines(0), 
    LinesCurves(1),
    Curves(2);
    
    private final int value;
    private VectorTypes(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum Animation
  {
    Static(0), 
    Movement(1),
    MultiMovement(2);
    
    private final int value;
    private Animation(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
      
  static enum AnimationSpeed
  {
    Slow(0), 
    Medium(1),
    Fast(2);
      
    private final int value;
    private AnimationSpeed(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum AnimationTypes
  {
    Horizontal(0), 
    Vertical(1),
    RotationX(2),
    RotationY(3),
    RotationZ(4);
      
    private final int value;
    private AnimationTypes(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
  
  static enum VectorColumns
  {
    X(0), 
    Y(1), 
    Z(2),
    Curve(3),
    ColorR(4),
    ColorG(5),
    ColorB(6);
      
    private final int value;
    private VectorColumns(int value) {
        this.value = value;
    }
  
    public int getValue() {
        return value;
    }
  };
}

class AnimationMovements
{
  private Enum.AnimationSpeed speed;
  private Enum.AnimationTypes types;
    
  private AnimationMovements(Enum.AnimationSpeed speed, Enum.AnimationTypes types) {
      this.speed = speed;
      this.types = types;
  }

  public Enum.AnimationSpeed getSpeed() {
      return this.speed;
  }
  
  public int getSpeedValue() {
      return this.speed.getValue();
  }
  
  public Enum.AnimationTypes getTypes() {
      return this.types;
  }
  
  public int getTypesValue() {
      return this.types.getValue();
  }
};